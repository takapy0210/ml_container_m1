c = get_config()
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8900
c.NotebookApp.notebook_dir = '/opt/program/working/'
c.LabApp.user_settings_dir = '/opt/program/working/jupyterlab/user-settings'
c.LabApp.workspaces_dir = '/opt/program/jupyterlab/workspaces'
c.NotebookApp.password = u'sha1:63cae364b3cd:c4319cba1eeb1bcf011a7d3fabd6448f95ae18c5'
