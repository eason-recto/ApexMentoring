@isTest
public class PaymentLinkCalloutMock implements HttpCalloutMock {

    public static final String PAYMENT_LINK = 'https://pry.me/p/1721958415';

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "paymentId": "9ddca32b-465b-4ffc-95d9-2a582c50a54a", "timestamp": "1721958415", "amount": 1234.56, "currency": "USD", "status": "Open", "paymentMethod": "Credit Card", "payer": { "id": "20e3d992-4f8e-45e3-bf19-8c3da7649b40", "link": "' + PAYMENT_LINK + '", "name": "John Doe", "email": "0@example.com", "address": { "street": "123 Main St", "city": "Springfield", "state": "Any State", "country": "USA" } }, "payee": { "id": "baec2bd4-540f-473a-88da-47c444c0337f", "name": "Acme Corp", "bankAccount": { "bankName": "Big Bank", "routingNumber": "817", "accountNumber": "271" } }, "transaction": { "transactionId": "5ac730fc-8ccd-4942-9316-4198523468c5", "transactionType": "Online Payment", "transactionStatus": "Success", "details": { "IP": "89.106.237.4", "location": "New York, USA", "device": "PC" } } }');
        response.setStatusCode(200);
        return response;
    }
}