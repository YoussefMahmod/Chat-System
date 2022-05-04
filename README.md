# README

## API Requirements Details (Ruby on Rails)

Actually that's my first time use ruby and ruby on rails, so maybe my code could miss some best practices.

1. It’s required to build a `chat system` using ruby on rails 5. The system should allow creating new applications where
   each application will have a `token`(generated by the system) and a name(provided by the client) The token is the identifier that devices use to send chats to that application.
2. each application starts from 1 and `no 2 chats in the same application may have the same number`. The number of the chat should be returned in the chat creation request. A chat
   contains messages and messages have numbers that start from 1 for each chat. The number of
   the message should also be returned in the message creation request. The client should never
   see the ID of any of the entities
3. Add an endpoint for searching through messages of a specific chat. It should be able to partially
   match `messages’ bodies`. You must use `ElasticSearch` for this.

4. The applications table should contain a column called chats_count that contains the number of
   chats for this application. Similarly, the chats table should contain a column called
   messages_count that contains the number of messages in this chat. These columns don’t have
   to be live. However, they shouldn’t be lagging more than 1 hour.

5. Try to minimize the queries and `avoid writing directly to MySQL` while serving the
   requests(especially for the chats and messages creation endpoints). You can use a queuing
   system to achieve that.
6. optimize your tables by adding appropriate `indices`.

7. Your app should be containerized. We will only write `docker-compose up` to run the whole
   stack if it doesn’t work, the task fails.
8. Write Specs.

## My Approach

As I love diagrams so I intialized a startup system design diagram.

![API System Design](readmeUtls/photos/system%20design.png)

<br>
<br>

> ### From the Requirements 1, 2

I've build a startup Database Design for our models (Applications, Chats, Messages) and implemented it using Ruby on Rails.

My Design

![API DB Design](readmeUtls/photos/Startup%20schema.png)

My Routes
![API Routes](readmeUtls/photos/my%20routes.png)

<br>
<br>

> ### From Requirement 2 every chat and message should have a unique serialized identifier.

I Think we can achieve Database Side, but i choosed to go with [`Redis INCR`](https://redis.io/commands/incr/) operator it's very fast O(1) and work atomically.

<br>
<br>

> ### From Requirement 3 we need to partially filter messages bodies using elasticsearch (it's similar to MySql wildcard '%messages bodies%' ).

After looking up the possible ways that this could be done, I guess using [`Ngrams`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-ngram-tokenfilter.html) is the right solution for us.
<br>
<br>

> ### From Requirement 4 we need to schedule task to update `messages_count` and `chats_count`

After looking up i found a gem called [`Whenever`](https://github.com/javan/whenever) which we can use to schedule tasks easily.

<br>
<br>

> ### From Requirement 5 we need to set a messaging queue

I think [`RabbitMQ`](https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html) fit well with our needs

<br>
<br>

> ### From Requirement 6 we need to adjust the database indices to minimize the response time.

![API DB Design with indexing](readmeUtls/photos/Database%20Indexing.png)
I assume that we are using B-Tree indexing

1. Application Table
   - I used a single index on (`token`) to help in looking up for a certain application.

<br>

2. Chat Table

   We will hit this table through two cases

   - Find All Chats belong to certain App by App_Token
   - Find certain chat belong to certain App by App_Token and Chat_Number

   So here i will use only composed index on App_Token and Chat_Number (Order is very important here)
   This index will serve both query.

<br>

3. Message Table
   We will hit this table through two cases

   - Find All Messages belong to certain App and chat by App_Token and Chat_Number.
   - Find certain Message belong to App and chat by App_Token, Chat_Number and Message_Number.

   Similar to last example i will use only composed index on App_Token and Chat_Number and Message_Number (Again order is very important here)

   This index will serve both query too.

<br>

### Note That

- We must `follow the order` of our indexing in `WHERE Clause` or we will lose it's functionality.
- We must `isolate` our fields in the WHERE Clause too.

  <br>
  <br>

> ### From Requirement 7 we need to compose up elasticsearch, mysql, rabbitmq, rails.

Actually, this is my first time touching docker but it doesn't really matter and my time ran out because of my exams so i'll KISS for Now and i'll optimized configuration in the future.

Update 1: I have an issue with messages worker i don't know why i can't up both of sneakers workers at the same time!! you can test workers locally it works correctly(I've no time due to my delayed midterm and Lab exam so i'll try to implement it in the future ISA).

Update 2: I fixed issues i think everything up correctly now finally!.

#### Requirements

For sure you need to have [Docker](https://docker.io) and [Docker Compose](https://docs.docker.com/compose/install/) installed.

#### Usage

Use the following command to run the app on [localhost:4000](localhost:4000)

```sh
docker-compose up -d
```

Stop the app using `docker-compose down`!

<br>
<br>

> ### From Requirement 8 we need to write specs for our api.

- `⚠ under construction!`.
