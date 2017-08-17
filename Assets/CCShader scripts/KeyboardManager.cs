using UnityEngine;
using System.Collections;

using UnityEngine.VR.WSA.Input;

namespace HoloToolkit.Unity
{
    // KeyboardManager uses input from a keyboard paired with HoloLens to select 
    // and display augmentations by mapping materials to the surface mesh
    public class KeyboardManager : MonoBehaviour
    {

        // Used to reference the spatial mapping
        private GameObject Player;
        SpatialMappingManager mappingMaterial;

        // Material to set
        public Material TransparentMaterial;
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
        public Material WireFrame;

        // Use this for initialization
        void Start()
        {
            // Get a reference to the spatial mapping mesh
            Player = GameObject.Find("SpatialMapping");
            mappingMaterial = Player.GetComponent<SpatialMappingManager>();
        }

        // Update is called once per frame
        void Update()
        {
            if (Input.GetKeyDown(KeyCode.Q))
            {
                mappingMaterial.SurfaceMaterial = TransparentMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.W))
            {
                mappingMaterial.SurfaceMaterial = RedToBlueMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.E))
            {
                mappingMaterial.SurfaceMaterial = BlueToRedMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.R))
            {
                mappingMaterial.SurfaceMaterial = RedToBlueBrightMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.T))
            {
                mappingMaterial.SurfaceMaterial = BlueToRedBrightMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.Y))
            {
                mappingMaterial.SurfaceMaterial = OrangeToPurpleMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.U))
            {
                mappingMaterial.SurfaceMaterial = PurpleToOrangeMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.I))
            {
                mappingMaterial.SurfaceMaterial = YellowToBlueMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.O))
            {
                mappingMaterial.SurfaceMaterial = BlueToYellowMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.P))
            {
                mappingMaterial.SurfaceMaterial = BlueLuminanceMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.A))
            {
                mappingMaterial.SurfaceMaterial = RedLuminanceMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.S))
            {
                mappingMaterial.SurfaceMaterial = GreenLuminanceMaterial;
            }

            else if (Input.GetKeyDown(KeyCode.D))
            {
                mappingMaterial.SurfaceMaterial = BlueToWhiteMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.F))
            {
                mappingMaterial.SurfaceMaterial = WhiteToBlueMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.G))
            {
                mappingMaterial.SurfaceMaterial = RedToWhiteMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.H))
            {
                mappingMaterial.SurfaceMaterial = WhiteToRedMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.J))
            {
                mappingMaterial.SurfaceMaterial = GreenToWhiteMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.K))
            {
                mappingMaterial.SurfaceMaterial = WhiteToGreenMaterial;
            }
            else if (Input.GetKeyDown(KeyCode.L))
            {
                mappingMaterial.SurfaceMaterial = WireFrame;
            }
        }
    }
}