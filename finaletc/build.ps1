# Attempt to build the docs
# creates english docs in /build/html and doctree in /build/doctree/
sphinx-build -b html -d build/doctrees source build/html 2> errors

# Fail if there are errors
if (Get-Content errors) {
    ./finaletc/reporter.ps1 fail

    exit 1
} else {
    ./finaletc/reporter.ps1 pass
}

# strip the branchname and make it a variable
$BRANCHNAME='master'

echo 'master'
echo $BRANCHNAME

# If we're on master or a release/* branch, deploy

# Deploy docs
./finaletc/docs.ps1

exit 0
