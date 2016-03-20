# if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo -e "Starting to update gh-pages\n"
  echo =========== GH_TOKEN =================
  echo $GH_TOKEN 
  #copy data we're interested in to other place
  # mkdir -p $HOME/coverage
  # cp -R $HOME/ss-install/bin/*.tar.gz $HOME/coverage

  #go to home and setup git
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"

  echo ===== about to clone ctng-ss-jekyllx ===============
  echo git clone https://${GH_TOKEN}@github.com/oglopss/ctng-ss-jekyll.git gh-pages-jekyll
  #using token clone gh-pages branch
  git clone https://${GH_TOKEN}@github.com/oglopss/ctng-ss-jekyll.git  gh-pages-jekyll > /dev/null

  #go into diractory and copy data we're interested in to that directory
  cd gh-pages-jekyll
  mkdir -p ss && cd ss
  # cp -Rf $HOME/coverage/* .

  #add, commit and push files
  git add -f .

  echo ======== show $SS_VER =======
  echo $SS_VER

  # need to regenerate _data/ss.yml
  cd ../_data

  datetime=$(date '+%d/%m/%Y %H:%M:%S %Z');

if grep -qe "build: $TRAVIS_BUILD_NUMBER$" ss.yml
then
    # code if found
    # update files
    if grep -qe "  - $SS_VER$" ss.yml
    then
        echo files already inside skip
    else
        cat >> ss.yml <<EOL
  - $SS_VER
EOL
    fi
  # update datetime
  sed -ie 's/^date:\s.*/date: $datetime/g' ss.yml

else
    # code if not found
    echo create new file


    cat > ss.yml <<EOL
build: $TRAVIS_BUILD_NUMBER
date: $datetime
files:
  - $SS_VER
EOL

fi
  

  
  echo ============= print ss.yml =============
  cat ./ss.yml
  # echo ============= we pull ss.yml =============
  
  
  git add -f ss.yml

  echo ============= commit ss.yml =============
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -f

  echo -e "Done magic with love\n"



# fi
