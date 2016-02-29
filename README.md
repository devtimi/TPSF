## TPSpecialFolders
The built in SpecialFolder does not support executable relative folders, such as one might use during a Build Step. This module provides easy access to those locations. The new framework has methods of accessing a couple of the app resource folders, but it seems there is no plan to add them to the old framework.

- Access locations used by Build Steps
- Able to find Libs folder on Windows (even if you remove the app name)
- Uses native declares to access bundle contents on Mac
- Cross Platform access to your Application Data folder with one line: TPSF.AppSupport()
- Get the app bundle identifier on Mac: App.BundleIdentifier()

Huge thanks to Sam Rowlands for all his help with the Mac declares!
