$SmartCardCode = @"
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Management.Automation;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Cryptography.X509Certificates;


namespace SmartCardLogon{

    static class NativeMethods
    {

        public enum CRED_MARSHAL_TYPE
        {
            CertCredential = 1,
            UsernameTargetCredential
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct CERT_CREDENTIAL_INFO
        {
            public uint cbSize;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
            public byte[] rgbHashOfCert;
        }

        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern bool CredMarshalCredential(
            CRED_MARSHAL_TYPE CredType,
            IntPtr Credential,
            out IntPtr MarshaledCredential
        );

        [DllImport("advapi32.dll", SetLastError = true)]
        public static extern bool CredFree([In] IntPtr buffer);

    }

    public class Certificate
    {

        public static PSCredential MarshalFlow(string thumbprint, SecureString pin)
        {
            //
            // Set up the data struct
            //
            NativeMethods.CERT_CREDENTIAL_INFO certInfo = new NativeMethods.CERT_CREDENTIAL_INFO();
            certInfo.cbSize = (uint)Marshal.SizeOf(typeof(NativeMethods.CERT_CREDENTIAL_INFO));

            //
            // Locate the certificate in the certificate store 
            //
            X509Certificate2 certCredential = new X509Certificate2();
            X509Store userMyStore = new X509Store(StoreName.My, StoreLocation.CurrentUser);
            userMyStore.Open(OpenFlags.ReadOnly);
            X509Certificate2Collection certsReturned = userMyStore.Certificates.Find(X509FindType.FindByThumbprint, thumbprint, false);
            userMyStore.Close();

            if (certsReturned.Count == 0)
            {
                throw new Exception("Unable to find the specified certificate.");
            }

            //
            // Marshal the certificate 
            //
            certCredential = certsReturned[0];
            certInfo.rgbHashOfCert = certCredential.GetCertHash();
            int size = Marshal.SizeOf(certInfo);
            IntPtr pCertInfo = Marshal.AllocHGlobal(size);
            Marshal.StructureToPtr(certInfo, pCertInfo, false);
            IntPtr marshaledCredential = IntPtr.Zero;
            bool result = NativeMethods.CredMarshalCredential(NativeMethods.CRED_MARSHAL_TYPE.CertCredential, pCertInfo, out marshaledCredential);

            string certBlobForUsername = null;
            PSCredential psCreds = null;

            if (result)
            {
                certBlobForUsername = Marshal.PtrToStringUni(marshaledCredential);
                psCreds = new PSCredential(certBlobForUsername, pin);
            }

            Marshal.FreeHGlobal(pCertInfo);
            if (marshaledCredential != IntPtr.Zero)
            {
                NativeMethods.CredFree(marshaledCredential);
            }
        
            return psCreds;
        }
    }
}
"@
Add-Type -TypeDefinition $SmartCardCode -Language CSharp
Add-Type -AssemblyName System.Security

# You can do more filtering here if there are other cert requirements...
$ValidCerts = [System.Security.Cryptography.X509Certificates.X509Certificate2[]](dir Cert:\CurrentUser\My | where { $_.NotAfter -gt (Get-Date) })

$ValidCerts# | select subject, DnsNameList, Issuer, EnhancedKeyUsageList, Archived, NotAfter | fl
#$Cert = $ValidCerts[0]
# You could check $ValidCerts, and not do this prompt if it only contains 1...
$Cert = [System.Security.Cryptography.X509Certificates.X509Certificate2UI]::SelectFromCollection(
    $ValidCerts,
    'Choose a certificate',
    'Choose a certificate',
    'SingleSelection'
) | select -First 1


$Pin = Read-Host "Enter your PIN: " -AsSecureString
$Cert = Write-Output ([SmartCardLogon.Certificate]::MarshalFlow($Cert.Thumbprint, $Pin))
$Cert