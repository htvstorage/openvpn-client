interval = 600000;
max = 10 * 24 * 60 * 60 * 1000 / interval;
i = 0;
z = 0;

function wait(ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}
f = async function() {
  try {
    z++;
    console.log(z + " " + Date());
    window.location.reload();
  } catch (ex) {
    console.log(ex)
  }

}
for (;;) {
  i++;
  if (i > max) {
    break;
  }
  setTimeout(f, i * interval);
}
console.log(max)
console.log(i)
