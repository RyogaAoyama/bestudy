//  アップロードした写真をその場でプレビュー
function imagePrev(e) {
  var reader = new FileReader();
  var file = e.target.files[0];
  var mimeType = file.type;
  var whitelist = [
    'image/jpeg',
    'image/png',
    'image/bmp'
  ];
  reader.onload = function(e) {
    if (whitelist.includes(mimeType)) {
      var imgTag = document.getElementById("prev");
      imgTag.src = e.target.result;
    }
  }
  reader.readAsDataURL(file);
}