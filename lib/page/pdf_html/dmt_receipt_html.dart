import 'package:esmartbazaar/model/receipt/money.dart';

class MoneyReceiptHtmlData {
  final MoneyReceiptResponse response;

  MoneyReceiptHtmlData(this.response);

  String mListData() {
    var mData = "";
    response.moneyReceiptDetail?.forEach((element) {
      mData += """
      <tr>
           <td>  ${element.transactionNumber} / ${response.transactionType} /${element.bankTxnId}</td>
           <td>${element.amount}</td>
           <td>${element.transactionStatus}</td>
      </tr>
    """;
    });
    return mData;
  }

  String printData() {
    return """
      <html xmlns="http://www.w3.org/1999/xhtml">
<head><title>
	Receipt
</title>

    <style type="text/css">
        .tdcolor {
            background-color: #f0f6ff;
         
        }

        .btn {
            font-family: 'Poppins', sans-serif;
            background: #00a65a;
            padding: 4px 20px;
            border: none;
            color: #fff;
            font-size: 12px;
            text-transform: capitalize;
        }

        h4 {
            padding: 0px !important;
            margin: 0px 0px 3px 0px !important;
            font-size: 12px;
        }
    </style>
  
</head>
<body>
 
       
        <div style="margin: 2px;">
            
                    <div>
                        <table style="border: solid 1px #000;">
                           <tr>
                                <td valign="top" colspan="2" align="center">
                                    <img src="https://esmartbazaar.in/images/sb_logo.png" style="width: 100px" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <h4>Payment Confirmation</h4>
                                    <hr />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Outlet Name :</h4>
                                   ${response.outletName}
                                </td>
                                <td>
                                    <h4>Mobile No :</h4>
                                    ${response.outletMobile}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Sender Name :</h4>
                                    ${response.senderName}
                                </td>
                                <td>
                                    <h4>Sender Mobile :</h4>
                                   ${response.senderNumber}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Beneficiary :</h4>
                                    ${response.beneficiaryName}
                                </td>
                                <td>
                                    <h4>Account No :</h4>
                                    ${response.accountNumber}
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Bank Name :</h4>
                                    ${response.bank}
                                </td>
                                <td>
                                    <h4>Date & Time :</h4>
                                    ${response.date}</td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <hr />
                                    <h4>Transaction Summary</h4>
                                </td>
                            </tr>
                            
                                    <tr>
                                        <td colspan="2">
                                            <table border="1" cellpadding="3" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <h4>TID/Type/UTR</h4>
                                                    </td>
                                                    <td>
                                                        <h4>Amount</h4>
                                                    </td>
                                                    <td>
                                                        <h4>Status</h4>
                                                    </td>
                                                </tr>
                                
                                    ${mListData()}
                                
                                    </table>
                                                    </td>
                                                </tr>
                                
                            <tr>
                                <td colspan="2">
                                    <h4>Total Amount : Rs. ${response.totalAmount}</h4>
                                    Amount (In Words) : ${response.amountInWords}
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <br /><br />
                                    <h4>&copy 2022 All Rights Reserved</h4>
                                    This is a system generated Receipt.
                                    Hence no seal or signature required.
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
                
        </div>
  
</body>
</html>

    
    """;
  }
}
