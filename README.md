![Nylo Banner](https://nylo.dev/images/nylo_logo_header.png)

<p align="center">
  <a href="https://github.com/nylo-core/nylo/releases"><img src="https://img.shields.io/github/v/release/nylo-core/nylo?style=plastic" alt="Latest Release Version"></a>
  <a href="https://github.com/nylo-core/nylo/blob/master/LICENSE"><img alt="GitHub" src="https://img.shields.io/github/license/nylo-core/nylo?style=plastic"></a>
  <a href="#"><img alt="GitHub stars" src="https://img.shields.io/github/stars/nylo-core/nylo?style=plastic"></a>
</p>

## Nylo

Nylo is a micro-framework for Flutter which is designed to help simplify developing apps. Every project provides a simple boilerplate and MVC pattern to help you build apps easier. 

This project is open source and MIT-licenced, we welcome any contributions. You can join as a backer/sponsor to fund future development for this project [here](https://nylo.dev)

---

## Features
Some core features available
* [Routing](https://nylo.dev/docs/5.20.0/router).
* [Themes and styling](https://nylo.dev/docs/5.20.0/themes-and-styling).
* [Localization](https://nylo.dev/docs/5.20.0/localization).
* [CLI for generating project files](https://nylo.dev/docs/5.20.0/metro).
* [Elegant API Services for Networking](https://nylo.dev/docs/5.20.0/networking).
* [Creating App Icons](https://nylo.dev/docs/5.20.0/app-icons).
* [Project Configuration](https://nylo.dev/docs/5.20.0/configuration).
* [Streamlined Project Structure](https://nylo.dev/docs/5.20.0/directory-structure).

## Requirements
* Dart >= 3.1.3

## Getting Started

``` bash
git clone https://github.com/nylo-core/nylo.git
```

## Documentation
View our [docs](https://nylo.dev/docs) and visit [nylo.dev](https://nylo.dev)

## Notes

Nylo Firebase implmentation: https://github.com/nylo-core/nylo/discussions/61

###  Afrikaburn GPS Coordinates

#### Center
32°30'59.42"S, 19°57'23.46"E
-32.5165, 19.9565

## iOS Firebase Configuration

To enable different firebase configurations for debug, relase & testing, a new build phase script needs to be created to copy the correct configuration file to the application on build.

Create two folders `FirebaseConfigs/{Debug,Release}` in the source root and add this folder to the project, add firebase configs in the respective folders.

Create the Build Phase `Copy Firebase Bundle Resources` in the Afrikaburn target.<br />
**Add all config files to Input Files.**

**NB!** Place this run script before any other firebase build phases.  It's important to have the config file available before anything else runs.

Here is a base template for the run script.

```bash
INFO_PLIST=GoogleService-Info.plist
DEVELOPMENT_INFO_PLIST=${PROJECT_DIR}/Runner/FirebaseConfigs/Debug/${INFO_PLIST}
RELEASE_INFO_PLIST=${PROJECT_DIR}/Runner/FirebaseConfigs/Release/${INFO_PLIST}

echo “Checking ${INFO_PLIST} in ${DEVELOPMENT_INFO_PLIST}”
if [ ! -f $DEVELOPMENT_INFO_PLIST ] ; then
    echo “Development GoogleService-Info.plist not found”
    exit 1
fi

echo “Checking ${INFO_PLIST} in ${RELEASE_INFO_PLIST}”
if [ ! -f $RELEASE_INFO_PLIST ] ; then
    echo “Release GoogleService-Info.plist not found”
    exit 1
fi

PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo “Attempting to copy ${INFO_PLIST} to final destination: ${PLIST_DESTINATION}”

if [ “${CONFIGURATION}” == “Release” ] ; then
    cp “${RELEASE_INFO_PLIST}” “${PLIST_DESTINATION}”
    echo “Copied ${RELEASE_INFO_PLIST}”
else
    cp “${DEVELOPMENT_INFO_PLIST}” “${PLIST_DESTINATION}”
    echo “Copied ${DEVELOPMENT_INFO_PLIST}”
fi
```

## iOS Firebase Crashlytics Configuration

To run this only on releases

```bas
if [ "${CONFIGURATION}" = "Release" ]; then
    // Script
fi
```

```bash
if [ "${CONFIGURATION}" = "Release" ]; then
fi


# And here you can see why that folder structure is important.
GOOGLESERVICE_INFO_PLIST=GoogleService-Info.plist
GOOGLESERVICE_INFO_PATH=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
GOOGLESERVICE_INFO_FILE=${GOOGLESERVICE_INFO_PLIST}/${GOOGLESERVICE_INFO_PLIST}
echo "Looking for GoogleService-Info.plist in ${GOOGLESERVICE_INFO_PATH}"

if [ -f "$GOOGLESERVICE_INFO_FILE" ]; then
    echo "Using GoogleService-Info.plist from ${GOOGLESERVICE_INFO_FILE}"

    # Get GOOGLE_APP_ID from GoogleService-Info.plist file
    APP_ID="$(grep -A1 GOOGLE_APP_ID ${GOOGLESERVICE_INFO_FILE} | tail -n1 | sed -e 's/.*\<string\>\(.*\)\<\/string\>/\1/')"

    # Run scripts to upload dSYMs to Firebase crashlytics
    "${PODS_ROOT}/FirebaseCrashlytics/run" -ai "${APP_ID}"
    "${PODS_ROOT}/FirebaseCrashlytics/upload-symbols" --build-phase --validate -ai "${APP_ID}"
    "${PODS_ROOT}/FirebaseCrashlytics/upload-symbols" --build-phase -ai "${APP_ID}"
    "${PODS_ROOT}/FirebaseCrashlytics/upload-symbols" -gsp "${GOOGLESERVICE_INFO_FILE}" -p ios "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"  -ai "${APP_ID}"
    
    echo "Successfully uploaded dSYMs to Firebase Crashlytics!"
else
    echo "GoogleService-Info.plist not found in ${GOOGLESERVICE_INFO_FILE}"
fi
```

#### NEW SCRIPTS

```bash
## Name
# [firebase_core] Copy Project Configuration File

## Script
echo "Firebase Environment: ${FIREBASE_ENVIRONMENT}"

# Name and path of the resource we're copying
GOOGLESERVICE_INFO_PLIST=GoogleService-Info.plist
GOOGLESERVICE_INFO_FILE=${PROJECT_DIR}/FirebaseConfig/${FIREBASE_ENVIRONMENT}/${GOOGLESERVICE_INFO_PLIST}

# Make sure GoogleService-Info.plist exists
echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_FILE}"
if [ ! -f $GOOGLESERVICE_INFO_FILE ]
then
    echo "No GoogleService-Info.plist found. Please ensure it's in the proper directory."
    echo "Expected path: ${GOOGLESERVICE_INFO_FILE}"
    exit 1
fi

# Get a reference to the destination location for the GoogleService-Info.plist
# This is the default location where Firebase init code expects to find GoogleServices-Info.plist file
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo "Will copy ${GOOGLESERVICE_INFO_PLIST} to final destination: ${PLIST_DESTINATION}"

# Copy over the prod GoogleService-Info.plist for Release builds
cp "${GOOGLESERVICE_INFO_FILE}" "${PLIST_DESTINATION}"

## Input Files
# $(PROJECT_DIR)/FirebaseConfig/$(FIREBASE_ENVIRONMENT)/GoogleService-Info.plist`
```

Input Files

```
${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}
$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)
```

## Firebase Analytics Debug View

Android

```bash
adb shell setprop debug.firebase.analytics.app io.wheresmyshit.afrikaburn.debug
adb shell setprop debug.firebase.analytics.app .none.
```

## Plugin Modifications :(

All difrect flutter plugin modifications need to be documented here incase there is an update
and the change is lost. Ideally a contribution to the original plugin should be be submitted with a pull request.

### flutter_pdfview

- https://github.com/endigo/flutter_pdfview
- https://developer.apple.com/documentation/pdfkit/pdfview/configurations/graphics_properties

The ability to set the PDFView.backgroundColor is not possible for iOS.  This change was made directly in the module file.
`FlutterPDFView.m` on `line 147`.

```objective-c
// Set PDF View to Asset UI Color
if([UIColor colorNamed:@"FlutterPDFView_BackgroundColor"]) {
    _pdfView.backgroundColor = [UIColor colorNamed:@"FlutterPDFView_BackgroundColor"];
}
```