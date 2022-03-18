#!/usr/bin/env python
# coding: utf-8

# In[2]:


# pip install psycopg2-binary


# In[23]:


# secret = 'your password goes here'


# In[15]:


import psycopg2 as pg2


# In[17]:


# establish connection with pgadmin
conn = pg2.connect(database = 'dvdrental', user = 'postgres', password = 'secret') # user 'postgres' is default


# In[18]:


# create a cursor
cur = conn.cursor()


# In[19]:


# execute some SQL query in the rental database
cur.execute('SELECT * FROM payment')


# In[20]:


# return the first row of the table
cur.fetchone()


# In[26]:


# how many rows we wanna fetch
cur.fetchmany(5)


# In[24]:


# fetch all rows from the query
# cur.fetchall()


# In[27]:


data = cur.fetchmany(5)


# In[28]:


# first row
data[0]


# In[34]:


# first row, second column
data[0][1]


# In[39]:


data[1][5]


# In[40]:


# closing connection
conn.close()


# In[ ]:




