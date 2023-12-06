import fs from "fs"


(async ()=>{
    var args = process.argv.slice(2);

    let csv2json=(f)=>{
        let data=fs.readFileSync(f,'utf-8');
         data=data.split('\n').filter(l=>l.length>0).map(e=>e.split(','))
        var head=data[0];
        data=data.slice(1)
        let newData = []
        data.forEach(e => {
            var ne = {}
            head.forEach((k,i)=>{
                if(k === 'code' || k === 'date'){
                    ne[k] = e[i]
                }else{
                    ne[k] = +e[i]
                }
            })
            newData.push(ne)
        });

        fs.writeFileSync(f.slice(0,f.length-3)+"json", JSON.stringify(newData))
        // console.table(newData)
    }

    for(let f of args){
        csv2json(f)
    }
    

})()


