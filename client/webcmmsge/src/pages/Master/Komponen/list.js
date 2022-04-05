import React from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';



class ListKomponen extends React.Component {
    /// null or empty handler
    nullcondition(params){
        if(params.data.keterangan===''){
            return 'xxx'
        }else{
            return params.data.keterangan
        }
    }
    constructor(props) {
        super(props)
        this.state = {
            /// state load data mesin for dropdown 
            dataMesin: '',
            /// flag for handlind data grid if false data grid hide 
            loadingKomponen: false,
            /// setate load data komponen
            dataKomponen: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "Nama Komponen",
                    field: 'nama',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                    valueGetter: this.nullcondition
                },
                {
                    headerName: "Kategori",
                    field: 'kategori',
                },
                // {
                //     headerName: 'Action',
                //     editable: false,
                //     sortable: false,
                //     filter: false,
                //     floatingFilter: false,
                //     field: 'idmesin',
                //     cellRenderer: (params) => <div><button type='button' className='btn btn-success'>Ubah</button></div>
                // }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: false,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    /// getting data komponen from api with parameter idmesin
    async loadDataKomponen(idmesin) {
        await axios.get("komponen/" + idmesin, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataKomponen: response.data.data })
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
        })
    }

    /// getting data mesin from api for dropdown mesin
    loadOptions = () => {
        return axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ loadingKomponen: true })
            const respon = response.data.data
            return respon
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
        })
    }

    render() {
        return (
            <div>
                {/* /// navigation bar */}
                <NavbarComponent />
                {/* /// header form */}
                <h1>Data Komponen</h1>
                {/* /// dropdown data mesin */}
                <AsyncSelect
                    cacheOptions
                    defaultOptions
                    getOptionLabel={e => e.nomesin}
                    getOptionValue={e => e.idmesin}
                    loadOptions={this.loadOptions}
                    placeholder="Pilih Mesin..."
                    gridOptions={this.state.gridOptions}
                    onChange={(value) => { this.loadDataKomponen(value.idmesin) }}
                />
                <br/>
                {/* /// condition to load data grid komponent */}
                {this.state.loadingKomponen && (
                    <div className='ag-theme-alpine' style={{ height: '100vh', width: '100vw' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataKomponen}
                            columnDefs={this.state.columnDefs}
                            // onGridReady={onGridReady}
                            animateRows={true}
                            defaultColDef={this.state.defaultColDef}
                            loadingCellRendererParams={this.state.loadingCellRendererParams}
                        />
                    </div>
                )}
            </div>
        );
    }
}

export default ListKomponen;
