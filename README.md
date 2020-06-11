# GEOAppS

The Geoscience Experiments and Observations Application Suite (GEOAppS) is a collection of interactive numerical models that provide visualizations of coastal processes. The suite can be customized to include/exclude models by updated the config.xml.
The current models included by default are:
* Wave refraction
* Wave-induced alongshore sediment transport
* Equilibrium beach profiles (Bruun's Rule)
* Sea cliff retreat

## Installing GEOAppS
GEOAppS can be installed on a MATLAB instance by running the `GEOAppS.mlappinstall` file found in the `install files` directory.
<br>Each model can also be installed as a standalone application by excecuting the corresponding `mlappinstall` file.

## Adding/removing an app
Any application which can be run from the MATLAB command line can be added to the GEOAppS suite.
<br> Apps are registered with GEOAppS by an `<app>` property in `config.xml`. 
<br> Apps must include the following properties:
* `<Name>`: A unique string identifier.
* `<Title>`: The display name of the application.
* `<Script>`: Name of file or command which executes the application.

Additionally, the following optional properties are supported:
* `<Author>`: Name of the application creator. Multiple authors should be listed under separate author tags.
* `<Description>`: A summary of the application/model which will appear in the GEOAppS landing page.
* `<ImgSrc>`: File path to an image which will appear in the GEOAppS landing page.
* `<Link>`: An optional web address for to direct users to more information. The address will appear as a hyperlink in the GEOAppS landing page.
