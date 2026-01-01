# Firefox DeclarativeNetRequest Bug Report

This repo contains three Firefox addons which demonstrate a bug in
Firefox regarding the `declarativeNetRequest` addon API.

<https://bugzilla.mozilla.org/show_bug.cgi?id=1995192>

## Test procedure

There are three extensions:

1. [Causes Conflict](https://github.com/radian-software/firefox-declarativenetrequest-bugreport/releases/download/v1.0.0/ext-causesconflict.xpi)
2. [Example Redirect Conflict](https://github.com/radian-software/firefox-declarativenetrequest-bugreport/releases/download/v1.0.0/ext-exampleredirect-conflict.xpi)
3. [Example Redirect Working](https://github.com/radian-software/firefox-declarativenetrequest-bugreport/releases/download/v1.0.0/ext-exampleredirect-noconflict.xpi)

If you install 1+2 simultaneously, then restart Firefox, navigating to
<https://www.example.com/> will have no effect. But if you
disable+reenable 2 then it will start redirecting you to
<https://www.mozilla.org/> when you visit <https://www.example.com/>

If you instead install 1+3 simultaneously, then restart Firefox,
navigating to <https://www.example.com/> will redirect you to
<https://www.mozilla.org/> right away without any need to
disable+reenable 3.

Extensions 2+3 are completely identical except for using different
addon IDs. They both use the `declarativeNetRequestWithHostAccess`
permission with a `rule_resources` JSON file to redirect
<https://www.example.com/> to <https://www.mozilla.org/>.

Extension 1 does absolutely nothing, but it also requests the
`declarativeNetRequestWithHostAccess` permission in its manifest.

As you can see, extension 1 somehow causes extension 2 to stop
working, but it doesn't cause any problems for extension 3, even
though extensions 2 and 3 are identical.

The reason for this is that apparently if multiple extensions try to
use the `declarativeNetRequestWithHostAccess` permission, then after
restarting Firefox, **only the extension whose addon ID is
alphabetically first will work properly**. The alphabetical order of
these extensions is 3-1-2, thus when installing 1+2, the placeholder
extension 1 stops extension 2 from working, but when installing 1+3,
then extension 3 will take precedence. Disabling+reenabling the
affected extension(s) causes them to return to normal behavior, until
a restart.
