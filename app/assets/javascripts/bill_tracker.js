window.BT = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    var bootstrap_data = JSON.parse($('#users_index_bootstrap').html());
    BT.users = new BT.Collections.Users(bootstrap_data.users);
    BT.balances = bootstrap_data.balances;
    BT.bills = new BT.Collections.Bills();

    BT.bills.on("add", this.recalculateBalances, this);

    new BT.Routers.AppRouter($('#content'));
    Backbone.history.start();
  },

  recalculateBalances: function(newBill) {
    newBill.billSplits.each(function(split) {
      BT.balances[split.debtor_id] += split.amount;
    });
    
    BT.bills.trigger("newBalances");
  },

  populateUserAutocompletes: function () {
    BT.userAutocompletes = [];
    BT.users.each(function (user) {
      BT.userAutocompletes.push(user.escape("email"));
      if (user.get("name")) {
        BT.userAutocompletes.push(user.escape("name"));
      }
    });
  },

  int_to_dec: function (int) {
    return (int/100).toFixed(2);
  },

  dec_to_int: function (dec) {
    return Math.floor(parseFloat(dec) * 100);
  }
};

$(document).ready(function(){
  BT.initialize();
});
