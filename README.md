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