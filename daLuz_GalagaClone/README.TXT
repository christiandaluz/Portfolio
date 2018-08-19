TO DO:

Fix ship animation thing
Proper enemy death sounds in contact listener
Player bounding/continuous force
Figure out bullet centering issue

Turn the music back on




if (!wave) {
            for (Enemy e : enemyList) {
                if (e.getX() < -50) {
                    //e.moveTo(e.xPos, e.yPos);
                    
                    //e.applyForce( new Vector2((e.getX() - e.xPos) * 3, -(e.getY() - e.yPos)* 3));
                    //e.setVelocityY(e.getSpeed());
                    
                    Vector2 direction = new Vector2(600 - e.getX(), -50 - e.getY()).nor();
                    float speed = e.getSpeed();
                    Vector2 trueDir = new Vector2(speed * direction.x, speed * direction.y);
                    
                    e.applyForce(trueDir);
                }
            }
        }
        
        if (!wave) {
            for (Enemy e : enemyList) {
                if (e.getY() > 600) {
                    //e.moveTo(e.xPos, e.yPos);
                    
                    //e.applyForce( new Vector2((e.getX() - e.xPos) * 3, -(e.getY() - e.yPos)* 3));
                    //e.setVelocityY(e.getSpeed());
                    
                    Vector2 direction = new Vector2(e.xPos - e.getX(), e.yPos - e.getY()).nor();
                    float speed = e.getSpeed();
                    Vector2 trueDir = new Vector2(speed * direction.x, speed * direction.y);
                    
                    e.applyForce(trueDir);
                }
            }
        }
        
        if (!wave) {
            for (Enemy e : enemyList) {
                if ( (e.getX() == e.xPos) && (e.getY() == e.yPos) && (e.isAttacking) ) {
                    //e.moveTo(e.xPos, e.yPos);
                    
                    //e.applyForce( new Vector2((e.getX() - e.xPos) * 3, -(e.getY() - e.yPos)* 3));
                    //e.setVelocityY(e.getSpeed());
                    
                    Vector2 direction = new Vector2(e.xPos - e.getX(), e.yPos - e.getY()).nor();
                    float speed = e.getSpeed();
                    Vector2 trueDir = new Vector2(speed * direction.x, speed * direction.y);
                    
                    e.setSpeed(0);
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
/*
        contactEvents = new ContactListener() 
        {
            public void beginContact(Contact contact) 
            {   
                Box2DActor actorA;
                Box2DActor actorB;
                
                actorA = GameUtils.getContactObjectFixture(contact, "Player", "action");
                actorB = GameUtils.getOtherContactObject(contact, "Player");
                if (actorA != null && actorB != null )
                {
                    player.addOverlap(actorB);
                }
                */
                
                /*   This will be powerups most likely

                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "Sword", "BoomerCase", "BombBag", "Bow", "Candle");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorB);
                    player.gotItem( actorB.getName() );
                    getItem.play();
                    if (actorB.getName().equals("Bow")) 
                        player.arrowCount += 10;
                    if (actorB.getName().equals("BombBag"))
                        player.bombCount += 4;
                }

                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "ArrowDrop");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorB);
                    ArrowDrop bonus = (ArrowDrop)actorB;
                    player.arrowCount += bonus.value;
                    getItem.play();
                }

                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "BombDrop");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorB);
                    BombDrop bonus = (BombDrop)actorB;
                    player.bombCount += bonus.value;
                    getItem.play();
                }

                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "Heart");
                if (actorA != null && actorB != null )
                {               
                    removeList.add(actorB);
                    player.health++;
                    getHeart.play();
                    if (player.health > player.maxHealth)
                        player.health = player.maxHealth;
                }

                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "HeartContainer");
                if (actorA != null && actorB != null )
                {               
                    removeList.add(actorB);
                    player.maxHealth++;
                    getHeart.play();
                }

                actorA = GameUtils.getContactObject(contact, "BombExplosion");
                actorB = GameUtils.getContactObject(contact, "");
                if (actorA != null)
                {
                    bombBlow.play();
                }
                */
                /*
                actorA = GameUtils.getContactObject(contact, "Bullet");
                actorB = GameUtils.getContactObject(contact, "Wasp");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorA);
                    
                    Enemy e = (Enemy)actorB;
                    enemyList.remove(e);
                    e.health--;
                    
                    enemy1death.play();
                    player.score += 50;
                }

                actorA = GameUtils.getContactObject(contact, "Bullet");
                actorB = GameUtils.getContactObject(contact, "Moth");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorA);
                    
                    Enemy e = (Enemy)actorB;
                    enemyList.remove(e);
                    e.health--;
                    
                    enemy1death.play();
                    player.score += 80;
                }

                actorA = GameUtils.getContactObject(contact, "Bullet");
                actorB = GameUtils.getContactObject(contact, "Boss");
                if (actorA != null && actorB != null )
                {
                    removeList.add(actorA);
                    
                    Enemy e = (Enemy)actorB;
                    enemyList.remove(e);
                    e.health--;
                    
                    enemy1death.play();
                    player.score += 150;
                }
                
                
                /*
                actorA = GameUtils.getContactObject(contact, "Player");
                actorB = GameUtils.getContactObject(contact, "Wasp", "Moth", "Boss");
                if (actorA != null && actorB != null )
                {
                    Player p = (Player)actorA;
                    removeList.add(actorA);
                    player.ships--;
                    player.health--;
                }
                */
                
                
                
                /*
                actorA = GameUtils.getContactObjectFixture(contact, "Player", "main");
                actorB = GameUtils.getContactObject(contact, "Bat", "Slime");
                if (actorA != null && actorB != null )
                {
                    player.health--;
                    System.out.println("Player hit by enemy " + actorB.getName() );
                    if (player.health <= 0)
                        System.out.println("You Lost...");
                    actorB.pushAway(player, 2f);

                    hurt.play();
                }
                
            }

            */
            /*
            public void endContact(Contact contact) 
            {
                Box2DActor actorA;
                Box2DActor actorB;

                /*
                actorA = GameUtils.getContactObjectFixture(contact, "Player", "action");
                actorB = GameUtils.getOtherContactObject(contact, "Player");
                if (actorA != null && actorB != null )
                {
                    player.removeOverlap(actorB);
                }
                */ /*
            }

            public void preSolve(Contact contact, Manifold oldManifold) { }

            public void postSolve(Contact contact, ContactImpulse impulse) { }
        };
        */
        

       
       
       
       
       
       

/* Unused Code bits

                int xVec = 0;
                if (e.getX() < e.getY()) {
                    xVec = (int) (e.getX() - player.getX()); 
                } else {
                    xVec = (int) (player.getX() - e.getX());
                }
                
                int yVec = (int) (e.getY() - player.getY());
                
                
                

                if ( keycode == Keys.A && player.hasItem("Bow") && player.arrowCount > 0 )
        {
            Arrow c = new Arrow();
            player.arrowCount--;
            c.setPosition( player.getActionCenter().x - c.getWidth()/2, player.getActionCenter().y - c.getHeight()/2  );

            float angle = player.getAnimationAngle();
            c.setRotation( angle * MathUtils.radiansToDegrees );
            c.setInitialVelocity( 3*MathUtils.cos(angle), 3*MathUtils.sin(angle) );
            addList.add(c);
            arrow.play();
        }

        if ( keycode == Keys.B && player.hasItem("BombBag") && player.bombCount > 0 )
        {
            Bomb c = new Bomb();
            player.bombCount--;
            c.setPosition( player.getActionCenter().x - c.getWidth()/2, player.getActionCenter().y - c.getHeight()/2  );
            addList.add(c);        
            bombDrop.play();
        }

        if ( keycode == Keys.C && player.hasItem("Candle") )
        {
            Flames c = new Flames();
            c.setPosition( player.getActionCenter().x - c.getWidth()/2, player.getActionCenter().y - c.getHeight()/2  );

            float angle = player.getAnimationAngle();
            c.setInitialVelocity( 0.5f*MathUtils.cos(angle), 0.5f*MathUtils.sin(angle) );
            addList.add(c);
            candle.play();
        }

        if ( keycode == Keys.I )
            player.printInventory();

        if ( keycode == Keys.D )
            viewDebugRenderer = !viewDebugRenderer;

        if ( keycode == Keys.L )
        {
            player.gotItem("Sword");
            player.gotItem("BoomerCase");
            player.gotItem("BombBag");
            player.gotItem("Bow");
            player.gotItem("Candle");
            player.health = 100;
            player.arrowCount = 100;
            player.bombCount = 100;
            player.rupeeCount = 100;
        }
                
*/



//e.moveTo(e.xPos, e.yPos);
                    
                    //e.applyForce( new Vector2((e.getX() - e.xPos) * 3, -(e.getY() - e.yPos)* 3));
                    //e.setVelocityY(e.getSpeed());
                    //e.addAction( Actions.sequence( Actions.moveTo(e.xPos, e.yPos)));
                    
                    
                    
                    /*
                    Vector2 direction = new Vector2(-50 - e.getX(), -50 - e.getY()).nor();
                    float speed = e.getSpeed();
                    Vector2 trueDir = new Vector2(speed * direction.x, speed * direction.y);
                    
                    e.applyForce(trueDir);
                    */
                    

                   
                   
                   
                   
                   
                   
                   
                   
                   
                           
        baseWasp = new PhysicsActor();
        Animation enemyAnim = GameUtils.parseSpriteSheet("assets/wasp.png", 2,1, 0.5f, PlayMode.LOOP_PINGPONG);
        baseWasp.storeAnimation( "default", enemyAnim );
        //baseWasp.setDeceleration(0);
        baseWasp.setSize(26,20);
        baseWasp.setEllipseBoundary();
        //baseWasp.setAutoAngle(true);
