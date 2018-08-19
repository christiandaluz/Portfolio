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

public class CreditsMenu extends BaseScreen
{
    
    public CreditsMenu(BaseGame g)
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
        
        //add instructions button
        TextButton instructionsButton = new TextButton("Instructions", game.skin, "uiTextButtonStyle");
        instructionsButton.addListener(
            new InputListener()
            {
                public boolean touchDown (InputEvent event, float x, float y, int pointer, int button) 
                {  return true;  }

                public void touchUp (InputEvent event, float x, float y, int pointer, int button) 
                {  
                    game.setScreen( new InstructionsMenu(game) );
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
        
        Label creditsBig = new Label("Credits", game.skin, "uiMediumStyle");
        Label credits =    new Label("Artwork and Sounds by Namco\n" +
                                     "Arcade Classic font by Jakob Fischer\n" +
                                     "Neuton Font by Brian Zick\n" +
                                     "Music by Goran Andric\n" +
                                     "Modifications by Christian da Luz", game.skin, "uiSmallestStyle");
        
        uiTable.add(title).colspan(2);
        uiTable.row();
        uiTable.add(creditsBig).colspan(2);
        uiTable.row();
        uiTable.add(credits).colspan(2).padTop(1);
        uiTable.row();
        uiTable.add(mainmenuButton).width(225).padTop(5).expandX();
        uiTable.add(startButton).width(225).padTop(5).expandX();
        uiTable.row();
        uiTable.add(instructionsButton).width(225).expandX();
        uiTable.add(quitButton).width(225).expandX();
        
        //uiTable.setDebug(true);
    }

    public void update(float dt) 
    {   
        
    }
}