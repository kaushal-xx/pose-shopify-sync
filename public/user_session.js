var product_sku = [];
if(__st['cid'] != undefined){
  $.ajax({ 
    url: "/apps/user_session/set_login?cid="+__st['cid'],
    dataType: 'jsonp',
    type: "POST"
  }).done(function(pdata) {
    console.log(pdata)
    product_sku = pdata.product_sku;
  });
}

$('a[href$="/account/logout"]').on('click', function(){
  $.ajax({ 
    url:  "/apps/user_session/set_logout?cid="+__st['cid'],
    dataType: 'jsonp',
    type: "POST"
  }).done(function(pdata) {
    console.log(pdata)
    product_sku = [];
  });
});