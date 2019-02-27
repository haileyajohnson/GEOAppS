fileId = '1ZfQeiOZFj7V6VISRxJXiNkpREH8BHTjk';
url = ['https://drive.google.com/uc?export=download&id=', fileId];

appFile = websave('Refraction.mlappinstall', url);
app = matlab.apputil.install(appFile);
matlab.apputil.run(app.id);