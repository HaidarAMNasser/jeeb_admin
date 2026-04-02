/// Merchant orders list filter (matches GET `status` + "others" client filter).
enum MerchantOrdersTab {
  pending,
  confirmed,
  others,
}

/// Query value for [GET /orders?status=] — null means no filter (used for "others" tab).
String? merchantTabToApiStatus(MerchantOrdersTab tab) {
  switch (tab) {
    case MerchantOrdersTab.pending:
      return 'PENDING';
    case MerchantOrdersTab.confirmed:
      return 'CONFIRMED';
    case MerchantOrdersTab.others:
      return null;
  }
}
