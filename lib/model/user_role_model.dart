// class UserRoleModel {
//   String email;
//   String userTitle;
//   String databaseId;
//   bool saleView;
//   bool saleEdit;
//   bool saleDelete;
//   bool partiesView;
//   bool partiesEdit;
//   bool partiesDelete;
//   bool purchaseView;
//   bool purchaseEdit;
//   bool purchaseDelete;
//   bool productView;
//   bool productEdit;
//   bool productDelete;
//   bool profileEditView;
//   bool profileEditEdit;
//   bool profileEditDelete;
//   bool addExpenseView;
//   bool addExpenseEdit;
//   bool addExpenseDelete;
//   bool lossProfitView;
//   bool lossProfitEdit;
//   bool lossProfitDelete;
//   bool dueListView;
//   bool dueListEdit;
//   bool dueListDelete;
//   bool stockView;
//   bool stockEdit;
//   bool stockDelete;
//   bool reportsView;
//   bool reportsEdit;
//   bool reportsDelete;
//   bool salesListView;
//   bool salesListEdit;
//   bool salesListDelete;
//   bool purchaseListView;
//   bool purchaseListEdit;
//   bool purchaseListDelete;
//
//   String? userKey;
//
//   UserRoleModel({
//     required this.email,
//     required this.userTitle,
//     required this.databaseId,
//     required this.saleView,
//     required this.saleEdit,
//     required this.saleDelete,
//     required this.partiesView,
//     required this.partiesEdit,
//     required this.partiesDelete,
//     required this.purchaseView,
//     required this.purchaseEdit,
//     required this.purchaseDelete,
//     required this.productView,
//     required this.productEdit,
//     required this.productDelete,
//     required this.profileEditView,
//     required this.profileEditEdit,
//     required this.profileEditDelete,
//     required this.addExpenseView,
//     required this.addExpenseEdit,
//     required this.addExpenseDelete,
//     required this.lossProfitView,
//     required this.lossProfitEdit,
//     required this.lossProfitDelete,
//     required this.dueListView,
//     required this.dueListEdit,
//     required this.dueListDelete,
//     required this.stockView,
//     required this.stockEdit,
//     required this.stockDelete,
//     required this.reportsView,
//     required this.reportsEdit,
//     required this.reportsDelete,
//     required this.salesListView,
//     required this.salesListEdit,
//     required this.salesListDelete,
//     required this.purchaseListView,
//     required this.purchaseListEdit,
//     required this.purchaseListDelete,
//     this.userKey,
//   });
//
//   factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
//         email: json["email"] ?? '',
//         userTitle: json["userTitle"] ?? '',
//         databaseId: json["databaseId"] ?? '',
//         saleView: json["saleView"] ?? false,
//         saleEdit: json["saleEdit"] ?? false,
//         saleDelete: json["saleDelete"] ?? false,
//         partiesView: json["partiesView"] ?? false,
//         partiesEdit: json["partiesEdit"] ?? false,
//         partiesDelete: json["partiesDelete"] ?? false,
//         purchaseView: json["purchaseView"] ?? false,
//         purchaseEdit: json["purchaseEdit"] ?? false,
//         purchaseDelete: json["purchaseDelete"] ?? false,
//         productView: json["productView"] ?? false,
//         productEdit: json["productEdit"] ?? false,
//         productDelete: json["productDelete"] ?? false,
//         profileEditView: json["profileEditView"] ?? false,
//         profileEditEdit: json["profileEditEdit"] ?? false,
//         profileEditDelete: json["profileEditDelete"] ?? false,
//         addExpenseView: json["addExpenseView"] ?? false,
//         addExpenseEdit: json["addExpenseEdit"] ?? false,
//         addExpenseDelete: json["addExpenseDelete"] ?? false,
//         lossProfitView: json["lossProfitView"] ?? false,
//         lossProfitEdit: json["lossProfitEdit"] ?? false,
//         lossProfitDelete: json["lossProfitDelete"] ?? false,
//         dueListView: json["dueListView"] ?? false,
//         dueListEdit: json["dueListEdit"] ?? false,
//         dueListDelete: json["dueListDelete"] ?? false,
//         stockView: json["stockView"] ?? false,
//         stockEdit: json["stockEdit"] ?? false,
//         stockDelete: json["stockDelete"] ?? false,
//         reportsView: json["reportsView"] ?? false,
//         reportsEdit: json["reportsEdit"] ?? false,
//         reportsDelete: json["reportsDelete"] ?? false,
//         salesListView: json["salesListView"] ?? false,
//         salesListEdit: json["salesListEdit"] ?? false,
//         salesListDelete: json["salesListDelete"] ?? false,
//         purchaseListView: json["purchaseListView"] ?? false,
//         purchaseListEdit: json["purchaseListEdit"] ?? false,
//         purchaseListDelete: json["purchaseListDelete"] ?? false,
//       );
//
//   Map<String, dynamic> toJson() => {
//         "email": email,
//         "userTitle": userTitle,
//         "databaseId": databaseId,
//         "saleView": saleView,
//         "saleEdit": saleEdit,
//         "saleDelete": saleDelete,
//         "partiesView": partiesView,
//         "partiesEdit": partiesEdit,
//         "partiesDelete": partiesDelete,
//         "purchaseView": purchaseView,
//         "purchaseEdit": purchaseEdit,
//         "purchaseDelete": purchaseDelete,
//         "productView": productView,
//         "productEdit": productEdit,
//         "productDelete": productDelete,
//         "profileEditView": profileEditView,
//         "profileEditEdit": profileEditEdit,
//         "profileEditDelete": profileEditDelete,
//         "addExpenseView": addExpenseView,
//         "addExpenseEdit": addExpenseEdit,
//         "addExpenseDelete": addExpenseDelete,
//         "lossProfitView": lossProfitView,
//         "lossProfitEdit": lossProfitEdit,
//         "lossProfitDelete": lossProfitDelete,
//         "dueListView": dueListView,
//         "dueListEdit": dueListEdit,
//         "dueListDelete": dueListDelete,
//         "stockView": stockView,
//         "stockEdit": stockEdit,
//         "stockDelete": stockDelete,
//         "reportsView": reportsView,
//         "reportsEdit": reportsEdit,
//         "reportsDelete": reportsDelete,
//         "salesListView": salesListView,
//         "salesListEdit": salesListEdit,
//         "salesListDelete": salesListDelete,
//         "purchaseListView": purchaseListView,
//         "purchaseListEdit": purchaseListEdit,
//         "purchaseListDelete": purchaseListDelete,
//       };
// }

class UserRoleModel {
  String email;
  String userTitle;
  String databaseId;
  bool salePermission;
  bool partiesPermission;
  bool purchasePermission;
  bool productPermission;
  bool profileEditPermission;
  bool addExpensePermission;
  bool lossProfitPermission;
  bool dueListPermission;
  bool stockPermission;
  bool reportsPermission;
  bool salesListPermission;
  bool purchaseListPermission;

  String? userKey;

  UserRoleModel({
    required this.email,
    required this.userTitle,
    required this.databaseId,
    required this.salePermission,
    required this.partiesPermission,
    required this.purchasePermission,
    required this.productPermission,
    required this.profileEditPermission,
    required this.addExpensePermission,
    required this.lossProfitPermission,
    required this.dueListPermission,
    required this.stockPermission,
    required this.reportsPermission,
    required this.salesListPermission,
    required this.purchaseListPermission,
    this.userKey,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
        email: json["email"] ?? '',
        userTitle: json["userTitle"] ?? '',
        databaseId: json["databaseId"] ?? '',
        salePermission: json["salePermission"] ?? false,
        partiesPermission: json["partiesPermission"] ?? false,
        purchasePermission: json["purchasePermission"] ?? false,
        productPermission: json["productPermission"] ?? false,
        profileEditPermission: json["profileEditPermission"] ?? false,
        addExpensePermission: json["addExpensePermission"] ?? false,
        lossProfitPermission: json["lossProfitPermission"] ?? false,
        dueListPermission: json["dueListPermission"] ?? false,
        stockPermission: json["stockPermission"] ?? false,
        reportsPermission: json["reportsPermission"] ?? false,
        salesListPermission: json["salesListPermission"] ?? false,
        purchaseListPermission: json["purchaseListPermission"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "userTitle": userTitle,
        "databaseId": databaseId,
        "salePermission": salePermission,
        "partiesPermission": partiesPermission,
        "purchasePermission": purchasePermission,
        "productPermission": productPermission,
        "profileEditPermission": profileEditPermission,
        "addExpensePermission": addExpensePermission,
        "lossProfitPermission": lossProfitPermission,
        "dueListPermission": dueListPermission,
        "stockPermission": stockPermission,
        "reportsPermission": reportsPermission,
        "salesListPermission": salesListPermission,
        "purchaseListPermission": purchaseListPermission,
      };
}
