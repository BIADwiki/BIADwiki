This folder contains the following files/folders that are on .gitignore:

.secret
gmailr.json

The gmailr.json was generated once using the gmail API: https://console.cloud.google.com/apis/dashboard via 'credentials' -> create and save a new JSON -> change file name.

The .secret was then generated using the R library gmailr, which uses the .json

Good advice here: https://github.com/jennybc/send-email-with-r