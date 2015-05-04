#include "mex.h"
#include "myMEX.h"
#define   real       double
#define   mxREAL_CLASS       mxDOUBLE_CLASS


#include "vtkFloatArray.h"
#include "vtkGenericCell.h"
#include "MESH2vtkPolyData.h"
#include "vtkPolyData2MESH.h"
#include "vtkGenericCell.h"
#include "vtkPolyDataNormals.h"
#include "vtkSmartPointer.h"
#include "vtkCellLocator.h"
#include "vtkIntersectionPolyDataFilter.h"


void CellsAreInside(vtkPolyData*, vtkPolyData*,  vtkIdList*, vtkIdList* );
void CopyCells(vtkPolyData* , vtkPolyData* , vtkIdList*);
void CopyCellsAndPoints(vtkPolyData*, vtkPolyData*, vtkIdList*);

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
 
  bool                CO;

 
  if(!nrhs){
    /*
    mexPrintf("vtkBooleanOperationPolyDataFilter( MESH1, MESH2, [CleanOut]\n");
    mexPrintf("\n");
    mexPrintf("Cleanout             	, boolean       	... (*) If true the output meshes contain only cell points \n");
    mexPrintf("                                                     If false the output meshes contain all input points  \n");
    mexPrintf("\n");*/
    if( nlhs ){ for (int i=0; i<nlhs; i++) plhs[i]=mxCreateDoubleMatrix( 0 , 0 , mxREAL ); }
    return;
  }
  
  if (nrhs<3) CO=true;
  else CO= myGetValue( prhs[2] ); 
  
  ALLOCATES();
  
  vtkPolyData         *MESH1;
  MESH1=MESH2vtkPolyData( prhs[0] );
  
  vtkPolyData         *MESH2;
  MESH2=MESH2vtkPolyData( prhs[1] );
 
  vtkIntersectionPolyDataFilter *PolyDataIntersection = vtkIntersectionPolyDataFilter::New();
  PolyDataIntersection->SetInput(0, MESH1);
  PolyDataIntersection->SetInput(1, MESH2);
  PolyDataIntersection->SplitFirstOutputOn();
  PolyDataIntersection->SplitSecondOutputOn();
  PolyDataIntersection->Update();
          
  vtkPolyData         *MESH1_T;
  MESH1_T=PolyDataIntersection->GetOutput( 1 );

          
  vtkSmartPointer< vtkIdList > interList = vtkSmartPointer< vtkIdList >::New();
  vtkSmartPointer< vtkIdList > unionList = vtkSmartPointer< vtkIdList >::New();
   
  vtkPolyData         *outputSurface; 

  CellsAreInside(MESH1_T, MESH2, interList,  unionList); 
         
  
  outputSurface = vtkPolyData::New();
  outputSurface->Allocate(MESH1_T);
  if (CO) CopyCellsAndPoints(MESH1_T, outputSurface,  unionList);
  else CopyCells(MESH1_T, outputSurface,  unionList);
  outputSurface->Squeeze();
  plhs[0]= vtkPolyData2MESH( outputSurface );
  outputSurface->Delete();
  
 
  outputSurface = vtkPolyData::New();
  outputSurface->Allocate(MESH1_T);
  if (CO) CopyCellsAndPoints(MESH1_T, outputSurface,  interList);
  else CopyCells(MESH1_T, outputSurface,  interList);
  outputSurface->Squeeze();
  plhs[1]= vtkPolyData2MESH( outputSurface );
  outputSurface->Delete();
  
  
  if (nlhs>2)
          
  {
  vtkPolyData         *MESH2_T;
  MESH2_T=PolyDataIntersection->GetOutput( 2 );
   
 
  interList->Reset();
  unionList->Reset();
  
  CellsAreInside(MESH2_T, MESH1, interList,  unionList); 
   
  outputSurface = vtkPolyData::New();
  outputSurface->Allocate(MESH2_T);
  if (CO) CopyCellsAndPoints(MESH2_T, outputSurface,  unionList);
  else CopyCells(MESH2_T, outputSurface,  unionList);
  outputSurface->Squeeze();
  plhs[2]= vtkPolyData2MESH( outputSurface );
  outputSurface->Delete();
  
  outputSurface = vtkPolyData::New();
  outputSurface->Allocate(MESH2_T);
  if (CO) CopyCellsAndPoints(MESH2_T, outputSurface,  interList);
  else CopyCells(MESH2_T, outputSurface,  interList);
  outputSurface->Squeeze();
  plhs[3]= vtkPolyData2MESH( outputSurface );
  outputSurface->Delete();
  
  }
  
  EXIT:
          PolyDataIntersection->Delete();
          MESH2->Delete();
          MESH1->Delete();

    myFreeALLOCATES();
}


// //-----------------------------------------------------------------------------
  void CellsAreInside(vtkPolyData* A, vtkPolyData* B,  vtkIdList* interList, vtkIdList* unionList)
  
  {
  
 
  vtkPolyDataNormals  *NORMALS;
  NORMALS= vtkPolyDataNormals::New();
  NORMALS->SetInput( B );
  NORMALS->ComputeCellNormalsOn();
  NORMALS->ComputePointNormalsOn();
  NORMALS->ConsistencyOff();
  NORMALS->AutoOrientNormalsOff();
  NORMALS->SplittingOff();
  NORMALS->Update();
  
  vtkPolyData* B_Normals;
  B_Normals=NORMALS->GetOutput();
  
  vtkCellLocator      *LOC;
  LOC= vtkCellLocator::New();
  LOC->SetDataSet( B_Normals );
  LOC->CacheCellBoundsOn();
  LOC->SetNumberOfCellsPerBucket( 2 );
  LOC->BuildLocator();
  LOC->Update();
  

  
  double dist, x[3],CellCent[3],closestPoint[3],N[3], *NN, pcoords[3], weigths[3], side,inumCellPts, bb[6];
  int j, sub;
  vtkIdList *cellPts, *CellPointIds;
  vtkIdType i, numCellPts, ptId, cellId, cell;
  vtkGenericCell  *Gcell;
  
  B_Normals->GetBounds(bb);
  Gcell = vtkGenericCell::New();
  CellPointIds = vtkIdList::New(); 
  cellPts=vtkIdList::New();


  
  for ( cellId = 0; cellId < A->GetNumberOfCells(); cellId++ )
  { 
    // Calculo del centro  
    A->GetCellPoints( cellId, cellPts );
    numCellPts=A->GetCell(cellId)->GetNumberOfPoints();
    inumCellPts  = 1/((double)numCellPts);
    CellCent[0]=0;CellCent[1]=0;CellCent[2]=0;
    for ( i = 0; i < numCellPts; i++ )
      {
        ptId = cellPts->GetId( i );
        A->GetPoint( ptId, x );
        for ( j = 0; j < 3; j++ )
            {
            CellCent[j]+=x[j];
            }
      }
      

    for (  j = 0; j < 3; j++ )
      {
        CellCent[j]=CellCent[j]*inumCellPts;
      }
    
    // Distancia del centro al otro MESH

    if( CellCent[0] < bb[0] || CellCent[0] > bb[1] ||
        CellCent[1] < bb[2] || CellCent[1] > bb[3] ||
        CellCent[2] < bb[4] || CellCent[2] > bb[5] ) 
    {
        unionList->InsertNextId( cellId );
        continue;
    }
    
     
    LOC->FindClosestPoint( CellCent , closestPoint , Gcell , cell, sub, dist);
            
    if( dist < 1e-10 ) 
    {
      // Sobre el poligono
      unionList->InsertNextId( cellId );
      interList->InsertNextId( cellId );
      continue;
    }
    
    B_Normals->GetCell(cell)->EvaluatePosition( closestPoint, NULL, sub, pcoords, dist, weigths );
    
    if( weigths[0]<1e-10 || weigths[1]<1e-10 || weigths[2]<1e-10 )
    {   
      // Sobre una arista
      B_Normals->GetCellPoints( cell , CellPointIds );
      NN = B_Normals->GetPointData()->GetNormals()->GetTuple3( CellPointIds->GetId(0) );
      for( j=0 ; j<3; j++ ){  N[j]  = NN[j]*weigths[0];  }
      NN = B_Normals->GetPointData()->GetNormals()->GetTuple3( CellPointIds->GetId(1) );
      for( j=0 ; j<3; j++ ){  N[j] += NN[j]*weigths[1];  }
      NN = B_Normals->GetPointData()->GetNormals()->GetTuple3( CellPointIds->GetId(2) );
      for( j=0 ; j<3; j++ ){  N[j] += NN[j]*weigths[2];  }
    } 
    else 
    {
      NN = B_Normals->GetCellData()->GetNormals()->GetTuple3(cell);
      for( j=0 ; j<3; j++ )
        {  
          N[j] = NN[j];  
        }
    }

    side= 0;
    for( j=0; j<3; j++ )
    {
      side += (closestPoint[j]-CellCent[j])*N[j];
    }
    
    if( side < 0 )
    {
      unionList->InsertNextId( cellId );
    } 
    else 
    {
      interList->InsertNextId( cellId );
    }
         
  }
  cellPts->Delete();
  CellPointIds->Delete();
  Gcell->Delete();
  LOC->Delete();
  NORMALS->Delete();
  
  
  }  

  
//-----------------------------------------------------------------------------
void CopyCells(vtkPolyData* in, vtkPolyData* out,
               vtkIdList* cellIds){
  
  vtkSmartPointer< vtkGenericCell > cell = vtkSmartPointer< vtkGenericCell> ::New();
  vtkSmartPointer< vtkIdList > newCellPts = vtkSmartPointer< vtkIdList >::New();
  out->SetPoints(in->GetPoints());
  for ( vtkIdType cellId = 0; cellId < cellIds->GetNumberOfIds(); cellId++ )
    {
    in->GetCell( cellIds->GetId( cellId ), cell );
    vtkIdList *cellPts = cell->GetPointIds();
    vtkIdType numCellPts = cell->GetNumberOfPoints();

    for ( vtkIdType i = 0; i < numCellPts; i++ )
      {
      newCellPts->InsertId( i, cellPts->GetId( i ) );
      }

    
    vtkIdType newCellId = out->InsertNextCell( cell->GetCellType(), newCellPts );
    newCellPts->Reset();
    } // for all cells
  }

//-----------------------------------------------------------------------------
void CopyCellsAndPoints(vtkPolyData* in, vtkPolyData* out,
               vtkIdList* cellIds)

{
  
   vtkIdType numPts = in->GetNumberOfPoints();

  if ( out->GetPoints() == NULL)
    {
    vtkSmartPointer< vtkPoints > points = vtkSmartPointer< vtkPoints >::New();
    out->SetPoints( points );
    }

  vtkPoints *newPoints = out->GetPoints();

  vtkSmartPointer< vtkIdList > pointMap = vtkSmartPointer< vtkIdList >::New();
  pointMap->SetNumberOfIds( numPts );
  for ( vtkIdType i = 0; i < numPts; i++ )
    {
    pointMap->SetId(i, -1);
    }

  // Filter the cells
  vtkSmartPointer< vtkGenericCell > cell = vtkSmartPointer< vtkGenericCell> ::New();
  vtkSmartPointer< vtkIdList > newCellPts = vtkSmartPointer< vtkIdList >::New();
  for ( vtkIdType cellId = 0; cellId < cellIds->GetNumberOfIds(); cellId++ )
    {
    in->GetCell( cellIds->GetId( cellId ), cell );
    vtkIdList *cellPts = cell->GetPointIds();
    vtkIdType numCellPts = cell->GetNumberOfPoints();

    for ( vtkIdType i = 0; i < numCellPts; i++ )
      {
      vtkIdType ptId = cellPts->GetId( i );
      vtkIdType newId = pointMap->GetId( ptId );
      if ( newId < 0 )
        {
        double x[3];
        in->GetPoint( ptId, x );
        newId = newPoints->InsertNextPoint( x );
        pointMap->SetId( ptId, newId );
        }
      newCellPts->InsertId( i, newId );
      }

    
    vtkIdType newCellId = out->InsertNextCell( cell->GetCellType(), newCellPts );
    newCellPts->Reset();
    } // for all cells

}
