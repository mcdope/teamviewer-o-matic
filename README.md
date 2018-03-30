### About ###

This script "remote control" the TeamViewer and TeamViewer Host installers to allow heavy users to deploy it unattended, without being forced to use the (imho way to expensive for private usage) MSI package.

---

### License ###

This project is licensed under the GPLv2. See the `LICENSE` file, or the [GNU website](https://www.gnu.org/licenses/gpl-2.0.txt), for details.

---

### Copyright / Trademarks ###
TeamViewer is a registered trademark by TeamViewer GmbH. I am in no way associated with the product or company, and without doubt they don't endorse this script.

---

### Usage overview ###

1. Compile the script into an actual executable, see the [AutoIt documentation](https://www.autoitscript.com/autoit3/docs/intro/compiler.htm) for details.
2. Copy `teamviewer-o-matic.conf.sample`, rename the copy to `teamviewer-o-matic.conf` and fill it with your details.
3. Run `teamviewer-o-matic.exe <full|host> <languageToUse>`, a tray tip telling you it's waiting for setup will appear.
4. Run the choosen TeamViewer installer and watch the magic.

---

#### Supported languages ####

 -  German - Use with "german" as param, translation by Tobias Bäumer
 -  Italian - Use with "italian" as param, translation by Simone Naldi

---

#### Supported TeamViewer versions ####
 -  TeamViewer 10
     - last tested with 10.0.47484 (german, italian, english)
     - branch `teamviewer-10`
     - released as `v2.0.10.<minor>`
	 - IMPORTANT: This branch is deprecated. All feature work will happen on teamviewer-11
 -  TeamViewer 11
     - last tested with 11.0.53254.0 (german, italian, russian)
     - branch `teamviewer-11`
     - released as `v2.0.11.<minor>`
 -  TeamViewer 12
     - last tested with 12.1.5697.0 (german only)
     - branch `teamviewer-12`
     - released as `v2.0.12.<minor>`
 -  TeamViewer 13
     - last tested with 13.0.6447
     - branch `teamviewer-13`
     - released as `v2.0.13.<minor>`

---

#### Config file `teamviewer-o-matic.conf` format details ####
##### Section `Setup` #####
 -  `AccountUsername`: Your registered TeamViewer account name or email
 -  `AccountPassword`: Password for `AccountUsername`
 -  `ConnectPassword`: Password to set for unattended client access

##### Section `Advanced` #####
 -  `SleepDelay`: The script will sleep on some "more intense" setup steps if this is larger zero. Can be used to increase reliability on slow machines.
 -  `SendKeyDelay`: Delay to wait between simulated keystrokes. Again, can be used to increase reliability on slow machines.

---

#### Importing a TeamViewer settings export ####

It is also possible to have teamviewer-o-matic import a settings export from TeamViewer. To do so simply export the settings from a manually configured client. You will get a `.reg` file then, put this file as `tv_full.reg` or `tv_host.reg` - depending on source / target - in the teamviewer-o-matic directory. It will get detected and imported then after the TeamViewer Setup is done.

##### Important infos about the settings import #####
I've never tested importing host settings on full, or the other way around. But I wouldn't recommend it, so don't mix them up.

Importing old settings on newer version seems to work, I tried by accident when testing the `teamviewer-11` branch. But again: I wouldn't recommend it.

Also keep in mind that, according to user reports, TeamViewer exports the settings incorrectly if running on x64. It creates entries like `HKEY_LOCAL_MACHINE\SOFTWARE\TeamViewer` while it should be `HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer`. You need to manually edit those (open the .reg file in Notepad or another text editor), else the file will get imported - but will have no effect.

This is because without editing the entries land in the registry section for x64 executables, but TeamViewer runs on the Wow6432 subsystem since it's a 32bit executable and so its RegRead api calls get redirected. (Correct me if I'm wrong, but that's how I understood Windows and its APIs)

---

#### Adding new languages ####

It's easy to add support for other languages.

If you intend to do so, I would highly appreciate if you fork this repository and send a pull request when done. If you aren't familiar with git and still want to contribute feel free to email me your created language file. I will integrate it then.

To add a new language:

1. Copy an existing language file (i.e `teamviewer-o-matic.strings.german.conf`), rename the copy to `teamviewer-o-matic.strings.myFancyLanguage.conf`. `myFancyLanguage` is what you will later use when running `teamviewer-o-matic.exe`.
2. Replace the texts in the categories `Full_WindowTitles`, `Full_WindowTexts`, `Host_WindowTitles`, `Host_WindowTexts` with their equivalents from the TeamViewer language you want to use. They are in order of appearance in setup flow, so it should be easy to get them even if you don't understand german. Else there is still Google Translate ;).
3. Replace the texts in `Full_TrayTips` and `Host_TrayTips` to also localize teamviewer-o-matic's traytips (optional).

In case you want to add support for english or russian, you can use the files from `teamviewer-12` branch as starting point. Both where supported at some point, but I personally don't need them and don't want to maintain them anymore.

---

#### Where to find binaries / already compiled releases? ####

See [my Blog](https://blog.mcdope.org/tags/teamviewer/) for occasional binary drops.
