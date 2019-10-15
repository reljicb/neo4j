MATCH(n)
DETACH DELETE n
;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/legal_fund.csv' AS line
CREATE (:LegalFund { legalFundUUID: line.legalFundUUID, legalFundName: line.legalFundName})
;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/sub_fund.csv' AS line
CREATE (:SubFund { subFundUUID: line.subFundUUID, subFundName: line.subFundName})

;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/share_class.csv' AS line
CREATE (:ShareClass { shareClassUUID: line.shareClassUUID, shareClassName: line.shareClassName, shareClassCurrency: line.shareClassCurrency})

;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/dealer.csv' AS line
CREATE (:Dealer { dealerUUID: line.dealerUUID, dealerName: line.dealerName, dealerCountry: line.dealerCountry})

;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/account.csv' AS line
CREATE (:Account { accountUUID: line.accountUUID, accountNumber: line.accountNumber, accountName: line.accountName, holderNature: line.holderNature, holderCountryOfResidence: line.holderCountryOfResidence})

;

LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/trade.csv' AS line
CREATE (:Trade { tradeUUID: line.tradeUUID, latePayment: line.latePayment, signedSettlementAmount: line.signedSettlementAmount, tradeDate: line.tradeDate})

;

LOAD CSV WITH HEADERS FROM "file:///var/lib/neo4j/import/subfund_belongsto_legalfund.csv" AS line
MATCH (sf:SubFund {subFundUUID: line.subFundUUID})
MATCH (lf:LegalFund {legalFundUUID: line.legalFundUUID})
MERGE (sf)-[:BELONGS_TO]->(lf)

;

LOAD CSV WITH HEADERS FROM "file:///var/lib/neo4j/import/shareclass_belongsto_subfund.csv" AS line
MATCH (sc:ShareClass {shareClassUUID: line.shareClassUUID})
MATCH (sf:SubFund {subFundUUID: line.subFundUUID})
MERGE (sc)-[:BELONGS_TO]->(sf)

;


LOAD CSV WITH HEADERS FROM "file:///var/lib/neo4j/import/account_belongsto_dealer.csv" AS line
MATCH (ac:Account {accountUUID: line.accountUUID})
MATCH (dl:Dealer {dealerUUID: line.dealerUUID})
MERGE (ac)-[:BELONGS_TO]->(dl)

;

LOAD CSV WITH HEADERS FROM "file:///var/lib/neo4j/import/trade_belongsto_account_shareclass.csv" AS line
MATCH (tr:Trade {tradeUUID: line.tradeUUID})
MATCH (ac:Account {accountUUID: line.accountUUID})
MATCH (sc:ShareClass {shareClassUUID: line.shareClassUUID})
MERGE (tr)-[:HAS]->(ac)
MERGE (tr)-[:HAS]->(sc)
