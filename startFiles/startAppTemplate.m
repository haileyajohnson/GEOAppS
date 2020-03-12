%% 
% Change to url of app source
fileId = '1ASkChtWxILyok3xMO70mTUhANgrzAHWL';
url = ['https://drive.google.com/uc?export=download&id=', fileId];

%%
% change to name of install file
appFile = websave('refraction.mlappinstall', url);

%%
% Do not change
app = matlab.apputil.install(appFile);
matlab.apputil.run(app.id);