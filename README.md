### About ###

This script "remote control" the TeamViewer and TeamViewer Host setups to allow heavy users to deploy it unattended, without being forced to use the MSI package.

### License ###

This project is licensed under the GPLv2. See the `LICENSE` file, or the [GNU website](https://www.gnu.org/licenses/gpl-2.0.txt), for details.

### Usage ###

1. Compile the script into an actual executable, see the [AutoIt documentation](https://www.autoitscript.com/autoit3/docs/intro/compiler.htm) for details
2. Copy `teamviewer-o-matic.conf.sample`, rename the copy to `teamviewer-o-matic.conf` and fill it with your details
3. Run `teamviewer-o-matic.exe <Full|Host> <languageToUse>`, a tray tip telling you it's waiting for setup will appear. Note that right now "german" is the only supported language.  
(And yes, `Full` or `Host` MUST be given in this casing - with first letter uppercase and rest lowercase)
4. Run the choosen TeamViewer installer and watch the magic.

It is also possible to have teamviewer-o-matic import a settings export from TeamViewer. To do so simply export the settings from a manually configured client. You will get a `.reg` file then, put this file as `tv_full.reg` or `tv_host.reg` - depending on source / target - in the teamviewer-o-matic directory. It will get detected and imported then after the TeamViewer Setup is done. 

##### Important infos about the settings import #####
I've never tested importing host settings on full, or the other way around. But I wouldn't recommend it, so don't mix them up.

Also keep in mind that, according to user reports, TeamViewer exports the settings incorrectly if running on x64. It creates entries like `HKEY_LOCAL_MACHINE\SOFTWARE\TeamViewer` while it should be `HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer`. You need to manually edit those (open the .reg file in Notepad or another editor), else the file will get imported - but will have no effect. This is because without editing the entries land in the registry section for x64 executables, but TeamViewer runs on the Wow6432 subsystem since it's a 32bit executable and its RegRead api calls get redirected. (Correct me if I'm wrong, but that's how I understood Windows and it's APIs)

##### Available languages & adding new languages ######

So far I've only created the needed file for german language support. It's easy to add support for other languages.

If you intend to do so, I would highly appreciate if you fork this repository and send a pull request when done. If you aren't familiar with git and still want to contribute feel free to email me your created language file. I will integrate it then.

To add a new language:

1. Copy `teamviewer-o-matic.strings.german.conf`, rename the copy to `teamviewer-o-matic.strings.myFancyLanguage.conf`. `myFancyLanguage` is what you will later use when running `teamviewer-o-matic.exe`
2. Replace the texts in the categories `Full_WindowTitles`, `Full_WindowTexts`, `Host_WindowTitles`, `Host_WindowTexts` with their equivalents from the TeamViewer installers you want to use. They are in order of appearance in setup flow, so it should be easy to get them even if you don't understand german. Else there is still Google Translate ;)
3. Replace the texts in `Full_TrayTips` and `Host_TrayTips` to also localize teamviewer-o-matic's traytips (optional)

##### Where to find binaries / already compiled releases? #####

See [my Blog](https://blog.mcdope.org/tags/teamviewer/) for occasional binary drops.
