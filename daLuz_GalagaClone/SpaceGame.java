import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Game;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.Texture.TextureFilter;
import com.badlogic.gdx.scenes.scene2d.ui.Label.LabelStyle;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton.TextButtonStyle;
import com.badlogic.gdx.graphics.g2d.NinePatch;

public class SpaceGame extends BaseGame
{
    public void create() 
    {  
        // initialize resources common to multiple screens
        
        // Bitmap font
        BitmapFont uiFont = new BitmapFont(Gdx.files.internal("assets/ArcadeWhite70.fnt"));
        uiFont.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        //uiFont.getData().setScale(0.5f);
        uiFont.getData().setScale(0.35f, 0.5f);
        skin.add("uiFont", uiFont);
        
        // Label style
        LabelStyle uiLabelStyle = new LabelStyle(uiFont, Color.RED);
        // using newDrawable allows color tint, vs getDrawable
        // uiLabelStyle.background = skin.newDrawable("dialogTex", new Color(1.0f,1.0f,1.0f,0.8f));
        skin.add("uiLabelStyle", uiLabelStyle);
        
        
        // Bitmap font
        BitmapFont uiFontWhite = new BitmapFont(Gdx.files.internal("assets/ArcadeWhite70.fnt"));
        uiFontWhite.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        //uiFont.getData().setScale(0.5f);
        uiFontWhite.getData().setScale(0.35f, 0.5f);
        skin.add("uiFontWhite", uiFontWhite);
        
        // Label style
        LabelStyle uiLabelStyleWhite = new LabelStyle(uiFontWhite, Color.WHITE);
        // using newDrawable allows color tint, vs getDrawable
        // uiLabelStyle.background = skin.newDrawable("dialogTex", new Color(1.0f,1.0f,1.0f,0.8f));
        skin.add("uiLabelStyleWhite", uiLabelStyleWhite);

        
        BitmapFont uiLargeFont = new BitmapFont(Gdx.files.internal("assets/Neuton100.fnt"));
        uiLargeFont.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        skin.add("uiLargeFont", uiLargeFont);

        // Large Label style
        LabelStyle uiLargeStyle = new LabelStyle(uiLargeFont, Color.WHITE);
        skin.add("uiLargeStyle", uiLargeStyle);

        
        //Create medium text style
        BitmapFont uiMediumFont = new BitmapFont(Gdx.files.internal("assets/Neuton80.fnt"));
        uiMediumFont.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        skin.add("uiMediumFont", uiMediumFont);

        // Label style
        LabelStyle uiMediumStyle = new LabelStyle(uiMediumFont, Color.WHITE);
        skin.add("uiMediumStyle", uiMediumStyle);
        
        
        //Create small text style
        BitmapFont uiSmallFont = new BitmapFont(Gdx.files.internal("assets/Neuton40.fnt"));
        uiSmallFont.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        skin.add("uiSmallFont", uiSmallFont);

        // Label style
        LabelStyle uiSmallStyle = new LabelStyle(uiSmallFont, Color.WHITE);
        skin.add("uiSmallStyle", uiSmallStyle);
        
        //Create smallest text style
        BitmapFont uiSmallestFont = new BitmapFont(Gdx.files.internal("assets/NeutonBold22.fnt"));
        uiSmallestFont.getRegion().getTexture().setFilter(TextureFilter.Linear, TextureFilter.Linear);
        skin.add("uiSmallestFont", uiSmallestFont);

        // Label style
        LabelStyle uiSmallestStyle = new LabelStyle(uiSmallestFont, Color.WHITE);
        skin.add("uiSmallestStyle", uiSmallestStyle);
        
        // TextButton style
        TextButtonStyle uiTextButtonStyle = new TextButtonStyle();

        uiTextButtonStyle.font      = uiSmallFont;
        uiTextButtonStyle.fontColor = Color.BLUE;
        
        Texture upTex = new Texture(Gdx.files.internal("assets/ninepatch-1.png"));
        skin.add("buttonUp", new NinePatch(upTex, 18,18,8,12)); //26 26 16 20
        uiTextButtonStyle.up = skin.getDrawable("buttonUp");
        
        Texture overTex = new Texture(Gdx.files.internal("assets/ninepatch-2.png"));
        skin.add("buttonOver", new NinePatch(overTex, 18,18,8,12) );
        uiTextButtonStyle.over = skin.getDrawable("buttonOver");
        uiTextButtonStyle.overFontColor = Color.BLUE;
        
        Texture downTex = new Texture(Gdx.files.internal("assets/ninepatch-3.png"));
        skin.add("buttonDown", new NinePatch(downTex, 18,18,8,12) );        
        uiTextButtonStyle.down = skin.getDrawable("buttonDown");
        uiTextButtonStyle.downFontColor = Color.BLUE;		

        skin.add("uiTextButtonStyle", uiTextButtonStyle);
        
        
        // Dialog background
        Texture dialogTex = new Texture(Gdx.files.internal("assets/dialog-white.png"));
        skin.add("dialogTex", new NinePatch(dialogTex, 12,12,12,12));

        
        // initialize and set start screen 
        GameMenu gm = new GameMenu(this);
        setScreen( gm );
    }
}