# Obtain the list of crowdin supported languages
# creates langs.json in root directory
Invoke-RestMethod https://api.crowdin.com/api/supported-languages?json -OutFile langs.json

# Build sources for crowdin
# creates /build/locale/ with *.pot files in it
sphinx-build -b gettext source build/locale

# creates /locale-src/en/LC_messages/ with *.po files in it
sphinx-intl update -p build/locale -l en -d locale-src 1>$null

# *.po -> *.mo in  /locale/lang_code/
sphinx-intl build -d locale/ 1>$null

# we need to know which releases are deployed before building the landing page and topbar

# clone old deployed docs
New-Item -Path deploy -Force -ItemType Directory
cd deploy
git init
# add origin as remote
git remote add origin 'https://github.com/Spongy/SpongeDocs.git' >$null
git checkout --orphan gh-pages
git pull origin gh-pages
cd ..

# create topbar and modifiy theme before building the docs
python ./finaletc/menubar.py $(Get-ChildItem locale -name |
tr '\n' ',' |
sed 's/,$//g')

# Build the english source
sphinx-build -b html source dist/$BRANCHNAME/en

# Build each language
Get-ChildItem locale -name | %{.\finaletc\sphinx_opts.ps1 $_} | %{Powershell -Command sphinx-build -b html $_}

# Build the homepage if we're on master branch
python ./finaletc/home.py $(Get-ChildItem locale -name |
tr '\n' ',' |
sed 's/,$//g')

# Copy static files
Copy-Item .\finaletc\static\* dist\$BRANCHNAME -Force -Recurse

# Copy static files to ~/ if we're building master
Copy-Item .\finaletc\static\* dist -Recurse -Force
Copy-Item .\dist\master\en\_static\* dist\_static -Force -Recurse

cd deploy

# remove the old build
Remove-Item $BRANCHNAME -Recurse -Force

# copy new build to /deploy/, commit and deploy.
cd ..
Copy-Item .\dist\* .\deploy -Recurse -Force
# Copy-Item -Path .\dist\ -Container -Destination .\deploy -Force -Recurse
cd deploy

cd ..