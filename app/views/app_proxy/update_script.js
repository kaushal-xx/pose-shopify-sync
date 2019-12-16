var variant_ids = [];
var variant_product_mapping = {};
if(Shopify.Checkout){
  $ = window.Checkout.$;
}

if(__st['cid'] != undefined){
  $.ajax({ 
    url: "/apps/user_session/set_login?cid="+__st['cid'],
    dataType: 'json',
    type: "POST"
  }).success(function(pdata) {
    variant_ids = pdata.shopify_variant_id;
    variant_product_mapping = pdata.shopify_product_mapping;
    setCookie('customer_'+__st['cid']+'_product_id', variant_ids)
    setCookie('customer_'+__st['cid']+'_product_mapping', JSON.stringify(variant_product_mapping))
    if(Shopify.Checkout){
      update_checkout_card(variant_ids);
    }else{
      mark_out_of_stock(variant_ids);
      hide_add_to_card(variant_ids);
      create_custom_field(variant_ids);
      update_card(variant_ids);
      update_min_card_page(variant_ids);
      update_card_page(variant_ids);
    }

  });
}

$('a[href$="/account/logout"]').on('click', function(){
  $.ajax({ 
    url:  "/apps/user_session/set_logout?cid="+__st['cid'],
    dataType: 'json',
    type: "POST"
  }).done(function(pdata) {
    variant_ids = [];
    variant_product_mapping = {};
  });
});

if(Shopify.Checkout){
  hide_checkout_link()
}else{
  hide_product_link();
}

$( document ).ready(function() {
  if(Shopify.Checkout){
    hide_checkout_link();
  }else{
    hide_product_link();
  }
});

function hide_product_link(){
  // if(__st['cid'] != undefined){
    var v_ids = getCookie('customer_'+__st['cid']+'_product_id');
    var v_mappings = getCookie('customer_'+__st['cid']+'_product_mapping');
    if(v_mappings != ''){
      variant_product_mapping = JSON.parse(v_mappings);
    }
    if(v_ids != ''){
      variant_ids = v_ids.split(',')
      mark_out_of_stock(variant_ids);
      create_custom_field(variant_ids);
      update_card(variant_ids);
      update_min_card_page(variant_ids);
      update_card_page(variant_ids);
      if($('body').hasClass('page-product')){
        hide_add_to_card(variant_ids)
      }
    }
  // }
}

function mark_out_of_stock(variant_ids){
  // if(__st['cid'] == 2840495947853){
    $( "div.prd-grid.product-listing div.prd.prd-style1").each(function( index ) {
      var out_of_stock = true
      var obj = this
      $.each(variant_ids, function( index, value ) {
        if($(obj).hasClass('product-id-'+value)){
          out_of_stock = false
        }
      });
      if(out_of_stock == true){
        if($(obj).hasClass('prd-outstock') == false){
          $(obj).addClass('prd-outstock product-item--not-available');
          $(obj).find('a.prd-img img.product-image').css('opacity','1');
          $(obj).find('a.prd-img').append("<div class='label-outstock'>Out Of Stock</div>");
        }
      }
    });
  // }
}

function hide_add_to_card(variant_ids){
  // if(__st['cid'] == 2840495947853){
    $( "button.btn--add-to-cart.js-add-to-cart-product-page").each(function( index ) {
      var out_of_stock = true;
      var obj = this;
      $.each(variant_ids, function( index, value ) {
        if($(obj).attr('data-variant-id') == value){
          out_of_stock = false
        }
      });
      if(out_of_stock == true){
        $(obj).hide();
        $(obj).parents('form').find('.prd-block_qty').hide();
        $(obj).parents('.prd-block_info').find('.prd-availability span').html('OUT STOCK');
      }
    });
  // }
}

function create_custom_field(variant_ids){
  // if(__st['cid'] == 2840495947853){
    $( "form[action='/cart/add']").each(function( index ) {
      var out_of_stock = true;
      var obj = this;
      var variant_id = $(obj).find("input[name='id']").val();
      $.each(variant_ids, function( index, value ) {
        if(variant_id == value){
          out_of_stock = false
        }
      });
      if(out_of_stock == false){
        if($(obj).find('input.product_skusub_sort').size() == 0){
          $(obj).find('button').before("<input class='product_skusub_sort' type='hidden' name='properties[_product_subsku_short]' value='"+variant_product_mapping[variant_id]+"'>");
        }
      }
    });
  // }
}

function update_card(variant_ids){
  // if(__st['cid'] == 2840495947853){
    var cart_info = {}
    var remove_variant = {updates: {}}
    jQuery.ajax({
      url: "/cart.json",
        type: "get"
    })
    .always(function(xhr, status){
      console.log(xhr);
      if(xhr.items == undefined){
        cart_info = JSON.parse(xhr.responseText).items
      }else{
        cart_info = xhr.items
      }
      jQuery.each(cart_info, function(index, line_item){
        if ($.inArray(""+line_item.variant_id+"", variant_ids) != -1){
          update_line_item(cart_info, index);
        }else{
          remove_variant['updates'][''+line_item.variant_id+'']=0;
        }
      });
      if(jQuery.isEmptyObject(remove_variant['updates']) == false){
        $.post('/cart/update.js', remove_variant);
      }
    });
  // }
}

function update_line_item(cart_info, index){
  line_item = cart_info[index]
  if(line_item != undefined){
    if(line_item.properties['_product_subsku_short'] == undefined){
      $.post('/cart/change.js', {
        id: line_item.key,
        properties: {
          '_product_subsku_short': variant_product_mapping[line_item.variant_id]
        }
      }).always(function(xhr, status){
        update_line_item(cart_info, index+1);
      });
    }else{
      update_line_item(cart_info, index+1)
    }
  }
}

function update_min_card_page(variant_ids){
  // if(__st['cid'] == 2840495947853){
    $( ".minicart-drop .minicart-prd").each(function( index ) {
      var out_of_stock = true;
      var obj = this;
      var variant_id = $(obj).find('.minicart-prd-action a.js-minicart-remove-item').attr('data-variant-id')
      $.each(variant_ids, function( index, value ) {
        if(variant_id == value){
          out_of_stock = false
        }
      });
      if(out_of_stock == true){
        $(obj).hide();
        $(obj).find('.minicart-prd-qty').html('Out Of Stock');
      }
    });
  // }
}

function update_card_page(variant_ids){
  // if(__st['cid'] == 2840495947853){
    $( ".cart-table .cart-table-prd").each(function( index ) {
      var out_of_stock = true;
      var obj = this;
      var variant_id = $(obj).find('.cart-table-prd-action a.icon-cross').attr('data-variant-id')
      $.each(variant_ids, function( index, value ) {
        if(variant_id == value){
          out_of_stock = false
        }
      });
      if(out_of_stock == true){
        $(obj).hide();
        $(obj).find('.cart-table-prd-qty .qty-changer').html('Out Of Stock');
      }
    });
  // }
}

function hide_checkout_link(){
    var v_ids = getCookie('customer_'+__st['cid']+'_product_id');
    var v_mappings = getCookie('customer_'+__st['cid']+'_product_mapping');
    if(v_mappings != ''){
      variant_product_mapping = JSON.parse(v_mappings);
    }
    if(v_ids != ''){
      variant_ids = v_ids.split(',')
      update_checkout_card(variant_ids);
    }
}

function update_checkout_card(variant_ids){
  // if(__st['cid'] == 2840495947853){
    var cart_info = {}
    var remove_variant = {updates: {}}
    $.ajax({
      url: "/cart.json",
        type: "get"
    })
    .always(function(xhr, status){
      console.log(xhr);
      if(xhr.items == undefined){
        cart_info = JSON.parse(xhr.responseText).items
      }else{
        cart_info = xhr.items
      }
      $.each(cart_info, function(index, line_item){
        if ($.inArray(""+line_item.variant_id+"", variant_ids) != -1){
          update_checkout_line_item(cart_info, index);
        }else{
          remove_variant['updates'][''+line_item.variant_id+'']=0;
          set_out_of_stock_checkout_label(line_item.variant_id);
        }
      });
      if($.isEmptyObject(remove_variant['updates']) == false){
        $.post('/cart/update.js', remove_variant);
      }
    });
  // }
}

function update_checkout_line_item(cart_info, index){
  line_item = cart_info[index]
  if(line_item != undefined){
    if(line_item.properties['_product_subsku_short'] == undefined){
      $.post('/cart/change.js', {
        id: line_item.key,
        properties: {
          '_product_subsku_short': variant_product_mapping[line_item.variant_id]
        }
      }).always(function(xhr, status){
        update_checkout_line_item(cart_info, index+1);
      });
    }else{
      update_checkout_line_item(cart_info, index+1)
    }
  }
}

function set_out_of_stock_checkout_label(variant_id){
  if($("#order-summary table.product-table tr.product[data-variant-id="+variant_id+"] span#out_of_stock").size() == 0){
    $("#order-summary table.product-table tr.product[data-variant-id="+variant_id+"]").find('th.product__description').append("<span id='out_of_stock' style='color:red;'>Out Of Stock</span>")
  }
  $('form.edit_checkout button#continue_button').hide()
}

function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
  var expires = "expires="+d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}