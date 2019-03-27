fileId = '1ASkChtWxILyok3xMO70mTUhANgrzAHWL';
url = ['https://drive.google.com/uc?export=download&id=', fileId];

appFile = websave('The Bruun Rule.mlappinstall', url);
app = matlab.apputil.install(appFile);
matlab.apputil.run(app.id);