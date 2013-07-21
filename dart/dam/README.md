Dam Version: 0.0.1
Author: Ewetumo Alexander Adeniyin
Details: Due to the cumbersome recurring case of dealing with packages folder and the fact that pub unlike
like node transverse the folder tree for a packages folder,i decided to create this small utility that 
provides these needs with the exception that instead of transversing,we use a global packages folder 
located in the home directory of the user and link/symlink to that folder. Since the packages folder are linked in,
running pub install will simple work as normal. Dam is intended to work as this so as not to in anyway insert itself
into pubs operations.

Options:

  :init (creates a new dart package folder "Pubpackages" in your home directory if it does not exists)

  :make (creates a new folder with the linked global packages(Pubpackages) folder and adds a default pubspec.yaml for you)
        eg. dam :setup name:'hello' desc:'say hello' dirs:lib,spec,framework

  :add (add a new folder that will have the global packages folder linked into it)
        eg. dam :add framework,extensions,apps

  :link (simple links into the directory the global packages(Pubpackages) folder)

