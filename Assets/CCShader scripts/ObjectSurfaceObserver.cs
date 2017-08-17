// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.

using System.Collections.Generic;
using UnityEngine;

namespace HoloToolkit.Unity
{
    public class ObjectSurfaceObserver : SpatialMappingSource
    {
        [Tooltip("The room model to use when loading meshes in Unity.")]
        public GameObject roomModel;
        //public GameObject camera;  // use the camera position (to adjust the room model relative to participant position)

        /// <summary>
        /// Loads the SpatialMapping mesh from the specified room object.
        /// </summary>
        /// <param name="roomModel">The room model to load meshes from.</param>
        public void Load(GameObject roomModel)
        {
            if (roomModel == null)
            {
                Debug.Log("No room model specified.");
                return;
            }

            GameObject roomObject = GameObject.Instantiate(roomModel);
            Cleanup();

            try
            {
                MeshFilter[] roomFilters = roomObject.GetComponentsInChildren<MeshFilter>();

                foreach (MeshFilter filter in roomFilters)
                {
                    GameObject surface = AddSurfaceObject(filter.sharedMesh, "roomMesh-" + surfaceObjects.Count, transform);
                    
                    // Get meh model transform information and adjust it
                    //Debug.Log("Test transform of Mesh 1: " + surface.GetComponent<Transform>().position); // current position of the mesh
                    //Debug.Log("Test transform of camera: " + camera.GetComponent<Transform>().position);  // current position of the camera
                    /// Do this: get transfor position of a spatial anchor or camera
                    /// then set  surface.GetComponent<Transform>().position and rotation to that anchor
                    //surface.GetComponent<Transform>().position = new Vector3(0.0f, 0.5f, 0.0f);           // set new position for mesh
                    //Debug.Log("Test transform of Mesh 2: " + surface.GetComponent<Transform>().position); // new mesh position

                    Renderer renderer = surface.GetComponent<MeshRenderer>();

                    if (SpatialMappingManager.Instance.DrawVisualMeshes == false)
                    {
                        renderer.enabled = false;
                    }

                    if (SpatialMappingManager.Instance.CastShadows == false)
                    {
                        renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
                    }

                    // Reset the surface mesh collider to fit the updated mesh. 
                    // Unity tribal knowledge indicates that to change the mesh assigned to a
                    // mesh collider, the mesh must first be set to null.  Presumably there
                    // is a side effect in the setter when setting the shared mesh to null.
                    MeshCollider collider = surface.GetComponent<MeshCollider>();
                    collider.sharedMesh = null;
                    collider.sharedMesh = surface.GetComponent<MeshFilter>().sharedMesh;
                }
            }
            catch
            {
                Debug.Log("Failed to load object " + roomModel.name);
            }
            finally
            {
                if (roomModel != null && roomObject != null)
                {
                    GameObject.DestroyImmediate(roomObject);
                }
            }
        }
    }
}