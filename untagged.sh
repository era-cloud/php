#!/usr/bin/env bash
set -Eeuo pipefail

OWNER="era-cloud"
REPO="php"
PACKAGE_NAME="php"
TOKEN=${GITHUB_TOKEN:-$(gh auth token)}
# 获取所有未标记的版本
# untagged_versions=$(curl -H "Authorization: bearer $TOKEN" -H "Accept: application/vnd.github.v3+json" \
# "https://api.github.com/user/packages/container/php/versions?per_page=200")
page=1
fctch(){
  echo $(curl -H "Authorization: bearer $TOKEN" -H "Accept: application/vnd.github.v3+json" \
"https://api.github.com/user/packages/container/php/versions?per_page=100&page=$page")
}

remove() {
  untagged_versions=$1
  # 循环删除每个未标记的版本
  for version in $untagged_versions; do
  {
    echo "Deleting version $version"
    curl -X DELETE -H "Authorization: bearer $TOKEN" -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/user/packages/container/php/versions/$version" -o /dev/null
  }&
  done
  wait
}
run(){
  result=$( fctch )
  if [ "$((echo $result) | jq -r '. | type')" == "array" ]; then
      length=($((echo $result) | jq -r '.[]'))
      if [ "${#length[@]}" -eq 0 ]; then
        echo 'empty tags'
        exit 0
      fi
      untagged_versions=($((echo $result) | jq -r '.[] | select(.metadata.container.tags | length == 0) | .id'))
      if [ "${#untagged_versions[@]}" -gt 0 ]; then
        remove $untagged_versions
        run
      else
        page=$((page+1))
        run
      fi
  fi
}
run