using UnityEngine;
using System.Collections;

// This class is used to pass the depth values of the Main Camera to the
// Color Shader and the Luminance Shader
public class PostProcessDepthGreyscale : MonoBehaviour {

    public Material RedToBlueMaterial;
    public Material BlueToRedMaterial;
    public Material RedToBlueBrightMaterial;
    public Material BlueToRedBrightMaterial;
    public Material OrangeToPurpleMaterial;
    public Material PurpleToOrangeMaterial;
    public Material YellowToBlueMaterial;
    public Material BlueToYellowMaterial;
    public Material BlueLuminanceMaterial;
    public Material RedLuminanceMaterial;
    public Material GreenLuminanceMaterial;
    public Material BlueToWhiteMaterial;
    public Material WhiteToBlueMaterial;
    public Material RedToWhiteMaterial;
    public Material WhiteToRedMaterial;
    public Material GreenToWhiteMaterial;
    public Material WhiteToGreenMaterial;

    // Use this for initialization
    void Start ()
    {
        RedToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToRedMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedToBlueBrightMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToRedBrightMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        OrangeToPurpleMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        PurpleToOrangeMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        YellowToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToYellowMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        GreenLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToRedMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        GreenToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToGreenMaterial.SetVector("_CameraPos", Camera.main.transform.position);
    }

    // Passes the depth texture to the materials containing the Color and Luminance Shaders
    private void Update()
    {
        RedToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToRedMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedToBlueBrightMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToRedBrightMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        OrangeToPurpleMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        PurpleToOrangeMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        YellowToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToYellowMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        GreenLuminanceMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        BlueToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToBlueMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        RedToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToRedMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        GreenToWhiteMaterial.SetVector("_CameraPos", Camera.main.transform.position);
        WhiteToGreenMaterial.SetVector("_CameraPos", Camera.main.transform.position);
    }
}
