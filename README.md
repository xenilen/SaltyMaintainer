PLEASE ANNOTATE NEW MODULES INSIDE .MODULE.TXT
need to make .module.txt into easy to read document with dropdowns/hyperlinks

format ad_getdomaincontrollers
forest_name {
    forest_dc1
    forest_dc2
    domain_name1{
        domain_dc
    }
    domain_name2{
        domain_dc
    }
}

TODO
-----
File in config folder to set multithread options for 


Goals
-------
Flexable modules that arent reliant on one thing (Modules/ WMI/ CIM)
Automate maintenance for all servers
Automate fixing issues found
- Alerts operators if issues can't be fixed (email/slack)
-- gathers information that could be useful/related
Expandable (Multithreaded/multiserver)
Able to function in any environment
Dynamic analytics (green/red to indepth readouts)
Easy to setup

Structure
------
GUI for analytics
- Easy to use
- Able to export to prefered filetype
- Editable dashboards
- Accessable from anywhere in environment

GUI for manual maintenance input
- Easy to use
- Clear messages for what is happening
- State saved incase of accidental closure

SaltyMaintainer ( job manager )
- Redundant
-- Multiple ways to execute tasks
- Secure
-- Uses Group managed service account
--- Minimal permissions to do job
