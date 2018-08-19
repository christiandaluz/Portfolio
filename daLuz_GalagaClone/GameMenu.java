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
import com.badlogic.gdx.Input.Keys;

public class GameMenu extends BaseScreen
{
    
    public GameMenu(BaseGame g)
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

        
        //set titleText
        BaseActor title = new BaseActor();
        title.setTexture( new Texture(Gdx.files.internal("assets/title.png")) );
        
        
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
        
        
        uiTable.add(title);
        uiTable.row();
        uiTable.add(startButton).width(225).padTop(10);
        uiTable.row();
        uiTable.add(instructionsButton).width(225).padTop(15);
        uiTable.row();
        uiTable.add(creditsButton).width(225).padTop(15);
        uiTable.row();
        uiTable.add(quitButton).width(225).padTop(15);
        
    }

    public void update(float dt) 
    {   
        
    }
    
    public boolean keyDown(int keycode)
    {
        if (keycode == Keys.S)    {
            game.setScreen( new GameScreen(game) );
        }
        
        return false;
    }
}