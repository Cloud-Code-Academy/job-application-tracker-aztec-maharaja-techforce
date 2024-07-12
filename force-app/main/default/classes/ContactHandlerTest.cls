@IsTest
public with sharing class ContactHandlerTest {
    @IsTest
    static void testSearchForCandidateByEmail(){
        Contact cont1 = new Contact(FirstName = 'Kevin', LastName = 'Test', Email = 'kevin@test.com');
        Contact cont2 = new Contact(FirstName = 'John', LastName = 'Test', Email = 'john@test.com');
        insert new List<Contact>{cont1,cont2};

        Contact searchContact = ContactHandler.searchForCandidateByEmail('kevin@test.com');
        Assert.areEqual(cont1.Id, searchContact.Id, 'Contact is incorrect');
    }

    @IsTest
    static void testCreateCandidate(){
        Contact cont1 = new Contact(FirstName = 'Kevin', LastName = 'Test', Email = 'kevin@test.com');
    }
}