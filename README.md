# Affiliates - Free Jekyll Theme

[Live Demo](https://wowthemesnet.github.io/affiliates-jekyll-theme/) | [Docs & Download](https://bootstrapstarter.com/template-affiliates-bootstrap-jekyll/) | 

![jekyll-affiliates-theme](https://bootstrapstarter.com/assets/img/themes/affiliates-jekyll.jpg)

```
git pull origin source
git pull origin master

<MAKE YOUR WEBSITE CHANGES IN SOURCE>

git add --all
git commit -m "your changes messages"
bundle exec jekyll build

<PUBLISH YOUR UPDATED SITE>

git checkout master
ls | grep -v '^_site$' | xargs rm -r <OPTIONAL>
cp -r _site/* .
git add .
git commit -m "Updated site version <X>"
git push origin master
```



## Helpful Git calls
Check which branch (aka version) you're in: `git branch`