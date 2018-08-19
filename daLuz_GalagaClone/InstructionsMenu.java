import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Button;
import com.badlogic.gdx.scenes.scene2d.ui.Button.ButtonStyle;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.InputListener;
import com.badlogic.gdx.graphics.g2d.Animation;
import com.badlogic.gdx.graphics.g2d.Animation.PlayMode;

public class InstructionsMenu extends BaseScreen
{
    
    public InstructionsMenu(BaseGame g)
    {
        super(g);
    }
    
    public void create() 
    {        
        //set background image
        Texture backTex = new Texture(Gdx.files.internal("assets/background.png"), true);
        backTex.setFilter(TextureFilter.Linear, TextureFilter.Linear);
        game.skin.add( "backTex", backTex );
        uiTable.background( game.skin.getDrawable("backTex") );
        
        //add main menu button
        TextButton mainmenuButton = new TextButton("Main Menu", game.skin, "uiTextButtonStyle");
        mainmenuButton.addListener(
            new InputListener()
            {
                public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) 
                {  return true;  }

                public void touchUp (InputEvent event, float x, float y, int pointer, int button) 
                {  
                    game.setScreen( new GameMenu(game) );
                }
        });
        
        //add start button
        TextButton startButton = new TextButton("Start", game.skin, "uiTextButtonStyle");
        startButton.addListener(
            new InputListener()
            {
                public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) 
                {  return true;  }

                public void touchUp (InputEvent event, float x, float y, int pointer, int button) 
                {  
                    game.setScreen( new GameScreen(game) );
                }
        });
        
        //add credits button
        TextButton creditsButton = new TextButton("Credits", game.skin, "uiTextButtonStyle");
        creditsButton.addListener(
            new InputListener()
            {
                public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) 
                {  return true;  }

                public void touchUp (InputEvent event, float x, float y, int pointer, int button) 
                {  
                    game.setScreen( new CreditsMenu(game) );
                }
        });
        
        //add quit button
        TextButton quitButton = new TextButton("Quit", game.skin, "uiTextButtonStyle");
        quitButton.addListener(
            new InputListener()
            {
                public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) 
                {  return true;  }

                public void touchUp (InputEvent event, float x, float y, int pointer, int button) 
                {  
                    Gdx.app.exit();
                }
        });
        
        //set titleText
        BaseActor title = new BaseActor();
        title.setTexture( new Texture(Gdx.files.internal("assets/title.png")) );
        
        Label instructBig = new Label("Instructions", game.skin, "uiMediumStyle");
        Label instructions = new Label("Defend your fighter against an alien attack!\n" +
                                       "Fire your laser to take out enemy ships\n" +
                                       "as they dive and shoot back at you.\n" +
                                       "Collect powerups to gain an edge against\n" +
                                       "the alien onslaught.\n" +
                                       "Space to fire, Left/Right Arrow to move\n" +
                                       "Wasp in Formation: 50 Pts.; Diving: 100 Pts.\n" +
                                       "Moth in Formation: 80 Pts.; Diving: 160 Pts.\n" +
                                       "Boss in Formation: 150 Pts.; Diving: 400 Pts.", game.skin, "uiSmallestStyle");
        
        uiTable.add(title).colspan(2);
        uiTable.row();
        uiTable.add(instructBig).colspan(2).padTop(4);
        uiTable.row();
        uiTable.add(instructions).colspan(2);
        uiTable.row();
        uiTable.add(mainmenuButton).width(225).padTop(15).expandX();
        uiTable.add(startButton).width(225).padTop(15).expandX();
        uiTable.row();
        uiTable.add(creditsButton).width(225).expandX();
        uiTable.add(quitButton).width(225).expandX();
        
        
        
        //uiTable.setDebug(true);
    }

    public void update(float dt) 
    {   
        
    }
}