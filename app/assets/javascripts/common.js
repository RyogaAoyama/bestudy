// URLの末尾に/newを結合する
function addToNewUrl() {
  let path = location.pathname;
  let pattern = /^.*\/new.*$/
  if(path.match(pattern)) return;
  
  history.replaceState('', '', `${ path }/new`)
}