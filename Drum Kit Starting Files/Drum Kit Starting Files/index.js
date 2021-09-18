

var drumNumbers = document.querySelectorAll(".drum")
for(i = 0 ; i < drumNumbers.length ; i++){
drumNumbers[i].addEventListener("click", function() {
  var audio = new Audio("sounds/crash.mp3")
  audio.play()
  console.log(event)

})
}
document.addEventListener("keypress", function(evasdasdnt) {
  console.log(addEventListener);
})
