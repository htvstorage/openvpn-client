(async () => {
    console.log("ok")
    var x = [];
    for (var i = 1; i < 1000; i++) {
        x.push(1000*Math.random());
    }

    
    x.forEach((element,index) => {
        console.log(element,index)
    });

    const getHi = val => {console.log(val); var t= Math.max(...x.slice(0)); console.log(t); return t;};

    console.log(getHi(x))
    // console.log(x.slice(1.3))


    let fd = new Date();    
    const fs = fd.getFullYear()+"-"+(fd.getMonth()+1)+"-"+fd.getDate()
    console.log(fs);
})();