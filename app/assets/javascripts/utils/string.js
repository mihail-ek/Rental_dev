String.prototype.truncate = 
  function(n){
      return this.substr(0,n-1)+(this.length>n?'...':'');
  };
