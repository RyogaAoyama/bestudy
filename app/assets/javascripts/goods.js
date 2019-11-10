function goodActive(id) {
  let noGoodClasses = document.getElementById(`js-no-good-${ id }`).classList;
  let goodClasses = document.getElementById(`js-good-${ id }`).classList;

  if (noGoodClasses.contains('active')) {
    goodClasses.replace('passive', 'active');
    noGoodClasses.replace('active', 'passive');
  } else {
    noGoodClasses.replace('passive', 'active');
    goodClasses.replace('active', 'passive');
  }
}
