fileId = '1mRrukaZAfXqGlaOnJAUrHXfT8yyO5Lw3';
url = ['https://drive.google.com/uc?export=download&id=', fileId];

appFile = websave('Sediment Transport.mlappinstall', url);
app = matlab.apputil.install(appFile);
matlab.apputil.run(app.id);