iOS Dev Toolbox
===========

Open-source app built using MVVM architecture, that provides some tools for iOS developers.
Current development build is on `develop` branch.

Tools
-----
Planned tools:

  - **Locale** – See all available locales and their components. Search for locales with specific values for testing. See all supported and exotic countries, languages and currencies.
  
  - **Calendar** – See calendar for given locale and default date and time formats. Build your own localized formats with live results. Convert timestamps to dates and vice versa.
  
  - **Time Zone** – See all time zones with their names, abbreviations, offsets and daylight savings. Convert dates using custom time zones.
  
  - **Characters** – Browse and search all Unicode characters code point, names, categories. See detailed info about each character including decomposing rules and related characters.
  
  - **Fonts** – See all installed fonts and preview any text. See font dimensions and attributes.
  
  - **…** any ideas?

MVVM or _MDV_
-------------
App is built using reactive framework [Objective-Chain](https://github.com/iMartinKiss/Objective-Chain). Some implemented tools don't need _Model_ layer, because I used standard Foundation classes. Instead of ugly term _ViewModel_, I prefer term _Design_, so the UI is made of two layers:

  - _View_ is how it looks.
  - _Design_ is how it works.

_Sounds familiar?_

_Design_ objects usualy belong to one _View Controller_ object. They take values from _Model_, format them for the UI and expose in public interface. _View Controllers_ manage _Views_ just like UIKit is designed and bind values from _Design_ layer.

---
© 2014 Triceratops Software s. r. o.  
_Viewing, forking, editing and contribution to the code is **encouraged**. Distribution in binary compiled form is **forbidden**, as stated in License file._