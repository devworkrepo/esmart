import 'package:esmartbazaar/model/receipt/credit_card.dart';

import '../../model/receipt/aeps.dart';

class CreditCardReceiptHtmlData{

  final CreditCardReceiptResponse response;
  CreditCardReceiptHtmlData(this.response);
  String printData() {
    return """
    
    <html xmlns="http://www.w3.org/1999/xhtml">
<head><title>

</title>
    <style type="text/css">
        .tdcolor {
            background-color: #f0f6ff;
            width: 177px;
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
            margin: 0px !important;
            font-size: 14px;
        }
    </style>
   
</head>
<body >
 
        <div style="margin: 2px;">
            <div style="border: solid 1px #000; width: 700px;">
                <table width="100%">
                    <tr>
                        <td style="width: 180px;" valign="top">
                            <img src="https://esmartbazaar.in/images/sb_logo.png" style="width: 120px;" />
                        </td>
                        <td colspan="2" align="center">
                            <h4>Credit Card Payment</h4>
                        </td>
                    
                    </tr>
                    <tr>
                        <td colspan="4">
                            <hr />
                        </td>
                    </tr>
                    
                            <tr>
                                <td style="width: 120px;">
                                    <h4>Outlet Name :</h4>
                                </td>
                                <td>${response.outletName}</td>
                                <td style="width: 130px;">
                                    <h4>Mobile No :</h4>
                                </td>
                                <td>${response.outletMobile}</td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Customer Name :</h4>
                                </td>
                                <td>${response.customerName}</td>
                                <td>
                                    <h4>Card Number :</h4>
                                </td>
                                <td>${response.cardNumber}</td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Card Type :</h4>
                                </td>
                                <td>${response.cardType}</td>
                                <td>
                                    <h4>Date & Time :</h4>
                                </td>
                                <td>${response.date}</td>
                            </tr>
                           
                            <tr>
                                <td>
                                    <h4>Trans No :</h4>
                                </td>
                                <td>${response.transactionNumber}</td>
                                <td>
                                    <h4>UTR No :</h4>
                                </td>
                                <td>${response.utrNumber}</td>
                            </tr>
                             <tr>
                                <td>
                                    <h4>Amount :</h4>
                                </td>
                                <td>${response.amount}</td>
                                
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <h4>Bank Message :</h4>
                                   ${response.transactionResponse}
                                </td>
                            </tr>
                        
                    <tr>
                        <td colspan="4">
                            <hr />
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="4" align="center">
                            <h4>&copy 2019 All Rights Reserved</h4>
                            This is a system generated Receipt. Hence no seal or signature required.
                                    <br />
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