
export  async function load(symbol){
    let a = await fetch("vnindex/20230220/VNINDEX_HOSE_5p.json",{
        headers : { 
          'Content-Type': 'application/json',
          'Accept': 'application/json'
         }
      });  
    return await a.json();
}

export  async function loadSymbol(symbol){
    let a = await fetch("agg/20230220/"+symbol+"_HOSE_5p.json",{
        headers : { 
          'Content-Type': 'application/json',
          'Accept': 'application/json'
         }
      });    
    return await a.json();
}
