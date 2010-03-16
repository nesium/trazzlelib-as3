### Description

The TrazzleLib contains the ActionScript connection classes needed to talk to Trazzle. It consists of two packages, one which contains barely the interface to the second, the core. This makes it easy to keep your logging statements for later or ongoing development, while removing unneeded code and unwanted insight into your app (nobody needs to see your logging messages, right?).

### How to use

MXMLC parameters for debugging:

`-library-path+=libc/TrazzleCore.swc -library-path+=libc/TrazzleLib.swc -include-libraries+=libc/TrazzleLib.swc`

MXMLC parameters for deployment:

`-library-path+=libc/TrazzleCore.swc -library-path+=libc/TrazzleLib.swc`

In your app, make sure you call `zz_init(stage, 'Your App Name')` first. 'Your App Name' will be displayed in the tab title in Trazzle.
Afterwards you can call `log()` and friends.

### See also

For more parameters either look in the source or try the demo app at http://github.com/nesium/trazzle-demo-app