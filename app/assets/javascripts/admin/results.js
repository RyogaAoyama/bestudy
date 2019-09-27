// formををsubmitするメソッド
function resultCreate() {
  form = document.getElementById("result-form");
  form.submit();
}

function pointCalc() {
  let radios = document.querySelectorAll('.radio');
  let point = 0;
  radios.forEach(function(radio) {
    if(radio.checked) {
      switch(radio.value) {
        case '1':
          point += 100;
          break;
        case '2':
          point += 80;
          break;
        case '3':
          point += 60;
          break;
        case '4':
          point += 40;
          break;
        case '5':
          point += 20;
          break;
        default:
          point += 0;
      }
    }
  });
  document.getElementById('point').innerHTML = point;
}