import '../../model/receipt/aeps.dart';

class AepsReceiptHtmlData {
  final AepsReceiptResponse response;
  final String title;

  AepsReceiptHtmlData(this.response,this.title);

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
                            <img src="https://esmartbazaar.in/images/sb_logo.png" style="width: 150px;" />
                        </td>
                        <td colspan="2" align="center">
                            <h4>${title}</h4>
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
                                <td>${response.outName}</td>
                                <td style="width: 130px;">
                                    <h4>Mobile No :</h4>
                                </td>
                                <td>${response.outletMobile}</td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Cust Mobile :</h4>
                                </td>
                                <td>${response.mobileNumber}</td>
                                <td>
                                    <h4>Cust Aadhar :</h4>
                                </td>
                                <td>${response.aadhaarNumber}</td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Bank Name :</h4>
                                </td>
                                <td>${response.bankName}</td>
                                <td>
                                    <h4>Date & Time :</h4>
                                </td>
                                <td>${response.date}</td>
                            </tr>
                            <tr>
                                <td>
                                    <h4>Amount :</h4>
                                </td>
                                <td>${response.amount}</td>
                                <td>
                                    <h4>Trans Type :</h4>
                                </td>
                                <td>
                                    ${(response.transactionType == "CW") ? "Cash Withdrawal" : (response.transactionType == "BE") ? "Balance Enquiry" : "Mini Statement"}
                                    
                                </td>
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
